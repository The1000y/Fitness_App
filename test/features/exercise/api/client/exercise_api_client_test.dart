import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/core/constants/api_strings.dart';
import 'package:fitness_app/features/exercise/api/client/exercise_api_client.dart';
import '../../../../helpers/fakes.dart';
import '../../../../helpers/test_data.dart';

void main() {
  late Dio dio;
  late FakeHttpClientAdapter adapter;
  late ExerciseApiClient client;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://fitness.elevateegy.com/api/v1'));
    adapter = FakeHttpClientAdapter();
    dio.httpClientAdapter = adapter;
    client = ExerciseApiClient(dio);
  });

  group('ExerciseApiClient', () {
    test('sends a GET request with both query parameters', () async {
      adapter.statusCode = 200;
      adapter.responseBody = TestData.exercisesListResponseJson;

      await client.getExercisesByMuscleDifficulty(
        TestData.primeMoverMuscleId,
        TestData.difficultyLevelId,
        1,
        10,
      );

      expect(adapter.callCount, 1);
      final options = adapter.lastRequestOptions!;
      expect(options.method, 'GET');
      expect(options.path, contains('/exercises/by-muscle-difficulty'));
      expect(
        options.uri.queryParameters['primeMoverMuscleId'],
        TestData.primeMoverMuscleId,
      );
      expect(
        options.uri.queryParameters['difficultyLevelId'],
        TestData.difficultyLevelId,
      );
      expect(options.uri.queryParameters['page'], '1');
      expect(options.uri.queryParameters['limit'], '10');
    });

    test('parses the exercises list response', () async {
      adapter.statusCode = 200;
      adapter.responseBody = TestData.exercisesListResponseJson;

      final response = await client.getExercisesByMuscleDifficulty(
        TestData.primeMoverMuscleId,
        TestData.difficultyLevelId,
        1,
        10,
      );

      expect(response.message, 'Success');
      expect(response.totalExercises, 2);
      expect(response.exercises, hasLength(2));
      expect(response.exercises?.first.exercise, 'Push Up');
    });

    test('throws DioException on a 401 response', () async {
      adapter.statusCode = 401;
      adapter.responseBody = {'message': 'Unauthorized'};

      await expectLater(
        client.getExercisesByMuscleDifficulty(
          TestData.primeMoverMuscleId,
          TestData.difficultyLevelId,
          1,
          10,
        ),
        throwsA(
          isA<DioException>()
              .having((e) => e.response?.statusCode, 'statusCode', 401)
              .having((e) => e.type, 'type', DioExceptionType.badResponse),
        ),
      );
    });

    test('sends a GET request with the prime mover query', () async {
      adapter.statusCode = 200;
      adapter.responseBody = TestData.difficultyLevelsResponseJson;

      await client.getDifficultyLevelsByPrimeMover(TestData.primeMoverMuscleId);

      expect(adapter.callCount, 1);
      final options = adapter.lastRequestOptions!;
      expect(options.method, 'GET');
      expect(
        options.path,
        contains('/levels/difficulty-levels/by-prime-mover'),
      );
      expect(
        options.uri.queryParameters['primeMoverMuscleId'],
        TestData.primeMoverMuscleId,
      );
    });

    test('parses the difficulty levels response', () async {
      adapter.statusCode = 200;
      adapter.responseBody = TestData.difficultyLevelsResponseJson;

      final response = await client.getDifficultyLevelsByPrimeMover(
        TestData.primeMoverMuscleId,
      );

      expect(response.message, 'Success');
      expect(response.totalLevels, 2);
      expect(response.difficultyLevels, hasLength(2));
      expect(response.difficultyLevels?.first.name, 'Beginner');
    });

    test('throws DioException when loading levels fails', () async {
      adapter.statusCode = 401;
      adapter.responseBody = {'message': 'Unauthorized'};

      await expectLater(
        client.getDifficultyLevelsByPrimeMover(TestData.primeMoverMuscleId),
        throwsA(
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'statusCode',
            401,
          ),
        ),
      );
    });

    test('gets all muscle groups', () async {
      adapter.responseBody = {
        'message': 'success',
        'musclesGroup': [
          {'_id': 'group-1', 'name': 'Abdominals'},
        ],
      };

      final response = await client.getMuscleGroups();

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

      final response = await client.getMusclesByGroup('group-1');

      expect(adapter.lastRequestOptions?.method, 'GET');
      expect(adapter.lastRequestOptions?.path, ApiStrings.musclesByGroup);
      expect(adapter.lastRequestOptions?.queryParameters, {
        ApiStrings.qMuscleGroupId: 'group-1',
      });
      expect(response.muscles?.single.name, 'Rectus Abdominis');
    });
  });
}
