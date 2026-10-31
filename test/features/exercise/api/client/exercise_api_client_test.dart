import 'package:dio/dio.dart';
import 'package:fitness_app/core/constants/api_strings.dart';
import 'package:fitness_app/features/exercise/api/client/exercise_api_client.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fakes.dart';

void main() {
  late FakeHttpClientAdapter adapter;
  late Dio dio;
  late ExerciseApiClient apiClient;

  setUp(() {
    adapter = FakeHttpClientAdapter();
    dio = Dio(BaseOptions(baseUrl: ApiStrings.baseUrl))
      ..httpClientAdapter = adapter;
    apiClient = ExerciseApiClient(dio);
  });

  tearDown(() {
    dio.close(force: true);
  });

  test('gets all muscle groups from the muscles endpoint', () async {
    adapter.responseBody = {
      'message': 'success',
      'musclesGroup': [
        {'_id': 'group-1', 'name': 'Abdominals'},
      ],
    };

    final response = await apiClient.getMuscles();

    expect(adapter.lastRequestOptions?.method, 'GET');
    expect(adapter.lastRequestOptions?.path, ApiStrings.muscles);
    expect(response.musclesGroup?.single.id, 'group-1');
  });

  test('gets muscles by group using the expected query parameter', () async {
    adapter.responseBody = {
      'message': 'success',
      'totalMuscles': 1,
      'muscles': [
        {
          '_id': 'muscle-1',
          'name': 'Rectus Abdominis',
          'image': 'https://example.com/rectus.png',
        },
      ],
    };

    final response = await apiClient.getMusclesByGroup('group-1');

    expect(adapter.lastRequestOptions?.method, 'GET');
    expect(adapter.lastRequestOptions?.path, ApiStrings.musclesByGroup);
    expect(adapter.lastRequestOptions?.queryParameters, {
      ApiStrings.qMuscleGroupId: 'group-1',
    });
    expect(response.muscles?.single.name, 'Rectus Abdominis');
  });
}
