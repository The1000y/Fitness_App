import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
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
  });
}
