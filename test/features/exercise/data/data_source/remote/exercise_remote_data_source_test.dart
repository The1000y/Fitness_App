import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/features/exercise/api/remote/exercise_remote_data_source_impl.dart';
import 'package:fitness_app/features/exercise/data/model/responses/exercises_list_response.dart';
import '../../../../../helpers/fakes.dart';
import '../../../../../helpers/test_data.dart';

void main() {
  late FakeExerciseApiClient fakeApiClient;
  late ExerciseRemoteDataSourceImpl dataSource;

  setUp(() {
    fakeApiClient = FakeExerciseApiClient();
    dataSource = ExerciseRemoteDataSourceImpl(fakeApiClient);
  });

  group('ExerciseRemoteDataSourceImpl', () {
    test('delegates the call with the given ids', () async {
      fakeApiClient.nextResponse = TestData.exercisesListResponse;

      final response = await dataSource.getExercisesByMuscleDifficulty(
        primeMoverMuscleId: TestData.primeMoverMuscleId,
        difficultyLevelId: TestData.difficultyLevelId,
      );

      expect(fakeApiClient.callCount, 1);
      expect(fakeApiClient.lastPrimeMoverMuscleId, TestData.primeMoverMuscleId);
      expect(fakeApiClient.lastDifficultyLevelId, TestData.difficultyLevelId);
      expect(response.totalExercises, 2);
    });

    test('returns the response produced by the api client', () async {
      fakeApiClient.nextResponse = ExercisesListResponse(
        message: 'Empty',
        totalExercises: 0,
        totalPages: 0,
        currentPage: 0,
        exercises: const [],
      );

      final response = await dataSource.getExercisesByMuscleDifficulty(
        primeMoverMuscleId: TestData.primeMoverMuscleId,
        difficultyLevelId: TestData.difficultyLevelId,
      );

      expect(response.message, 'Empty');
      expect(response.exercises, isEmpty);
    });

    test('propagates errors thrown by the api client', () async {
      fakeApiClient.nextError = Exception('boom');

      await expectLater(
        dataSource.getExercisesByMuscleDifficulty(
          primeMoverMuscleId: TestData.primeMoverMuscleId,
          difficultyLevelId: TestData.difficultyLevelId,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
