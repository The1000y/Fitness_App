import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/exercise/data/model/responses/exercises_list_response.dart';
import 'package:fitness_app/features/exercise/data/repo_impl/exercise_repo_impl.dart';
import '../../../../helpers/fakes.dart';
import '../../../../helpers/test_data.dart';

void main() {
  late FakeExerciseRemoteDataSource fakeRemote;
  late ExerciseRepoImpl repo;

  setUp(() {
    fakeRemote = FakeExerciseRemoteDataSource();
    repo = ExerciseRepoImpl(fakeRemote);
  });

  group('ExerciseRepoImpl', () {
    test('returns Success with the mapped entity', () async {
      fakeRemote.nextResponse = TestData.exercisesListResponse;

      final result = await repo.getExercisesByMuscleDifficulty(
        primeMoverMuscleId: TestData.primeMoverMuscleId,
        difficultyLevelId: TestData.difficultyLevelId,
      );

      expect(fakeRemote.callCount, 1);
      expect(fakeRemote.lastPrimeMoverMuscleId, TestData.primeMoverMuscleId);
      expect(fakeRemote.lastDifficultyLevelId, TestData.difficultyLevelId);
      expect(result, isA<Success<dynamic>>());
      final data = (result as Success).data;
      expect(data.totalExercises, 2);
      expect(data.exercises, hasLength(2));
      expect(data.exercises.first.exercise, 'Push Up');
    });

    test('returns Error with TimeoutFailure on timeout', () async {
      fakeRemote.nextError = DioException(
        requestOptions: RequestOptions(path: '/exercises/by-muscle-difficulty'),
        type: DioExceptionType.receiveTimeout,
      );

      final result = await repo.getExercisesByMuscleDifficulty(
        primeMoverMuscleId: TestData.primeMoverMuscleId,
        difficultyLevelId: TestData.difficultyLevelId,
      );

      expect(result, isA<Error<dynamic>>());
      expect((result as Error).failure, isA<TimeoutFailure>());
    });

    test(
      'returns Error with InternetConnectionFailure on connectionError',
      () async {
        fakeRemote.nextError = DioException(
          requestOptions: RequestOptions(
            path: '/exercises/by-muscle-difficulty',
          ),
          type: DioExceptionType.connectionError,
        );

        final result = await repo.getExercisesByMuscleDifficulty(
          primeMoverMuscleId: TestData.primeMoverMuscleId,
          difficultyLevelId: TestData.difficultyLevelId,
        );

        expect(result, isA<Error<dynamic>>());
        expect((result as Error).failure, isA<InternetConnectionFailure>());
      },
    );

    test('returns Error with UnauthorizedFailure on a 401 response', () async {
      fakeRemote.nextError = DioException(
        requestOptions: RequestOptions(path: '/exercises/by-muscle-difficulty'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(
            path: '/exercises/by-muscle-difficulty',
          ),
          statusCode: 401,
          data: {'message': 'Token expired'},
        ),
      );

      final result = await repo.getExercisesByMuscleDifficulty(
        primeMoverMuscleId: TestData.primeMoverMuscleId,
        difficultyLevelId: TestData.difficultyLevelId,
      );

      expect(result, isA<Error<dynamic>>());
      final failure = (result as Error).failure as UnauthorizedFailure;
      expect(failure.serverMessage, 'Token expired');
    });

    test('returns Error with UnknownFailure on a non Dio exception', () async {
      final originalDebugPrint = debugPrint;
      debugPrint = (_, {wrapWidth}) {};

      try {
        fakeRemote.nextError = Exception('Unexpected');

        final result = await repo.getExercisesByMuscleDifficulty(
          primeMoverMuscleId: TestData.primeMoverMuscleId,
          difficultyLevelId: TestData.difficultyLevelId,
        );

        expect(result, isA<Error<dynamic>>());
        expect((result as Error).failure, isA<UnknownFailure>());
      } finally {
        debugPrint = originalDebugPrint;
      }
    });

    test('maps an empty payload to an entity with defaults', () async {
      fakeRemote.nextResponse = ExercisesListResponse();

      final result = await repo.getExercisesByMuscleDifficulty(
        primeMoverMuscleId: TestData.primeMoverMuscleId,
        difficultyLevelId: TestData.difficultyLevelId,
      );

      expect(result, isA<Success<dynamic>>());
      final data = (result as Success).data;
      expect(data.message, '');
      expect(data.totalExercises, 0);
      expect(data.exercises, isEmpty);
    });
  });
}
