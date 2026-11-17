import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/features/exercise/api/remote/exercise_remote_data_source_impl.dart';
import 'package:fitness_app/features/exercise/data/model/responses/exercises_list_dto.dart';
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
        page: 1,
        limit: 10,
      );

      expect(fakeApiClient.callCount, 1);
      expect(fakeApiClient.lastPrimeMoverMuscleId, TestData.primeMoverMuscleId);
      expect(fakeApiClient.lastDifficultyLevelId, TestData.difficultyLevelId);
      expect(fakeApiClient.lastPage, 1);
      expect(fakeApiClient.lastLimit, 10);
      expect(response.totalExercises, 2);
    });

    test('returns the response produced by the api client', () async {
      fakeApiClient.nextResponse = ExercisesListDto(
        message: 'Empty',
        totalExercises: 0,
        totalPages: 0,
        currentPage: 0,
        exercises: const [],
      );

      final response = await dataSource.getExercisesByMuscleDifficulty(
        primeMoverMuscleId: TestData.primeMoverMuscleId,
        difficultyLevelId: TestData.difficultyLevelId,
        page: 1,
        limit: 10,
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
          page: 1,
          limit: 10,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('delegates the difficulty levels call', () async {
      fakeApiClient.nextLevelsResponse = TestData.difficultyLevelsResponse;

      final response = await dataSource.getDifficultyLevelsByPrimeMover(
        primeMoverMuscleId: TestData.primeMoverMuscleId,
      );

      expect(fakeApiClient.lastPrimeMoverMuscleId, TestData.primeMoverMuscleId);
      expect(response.totalLevels, 2);
      expect(response.difficultyLevels, hasLength(2));
    });

    test('propagates difficulty levels errors', () async {
      fakeApiClient.nextError = Exception('levels boom');

      await expectLater(
        dataSource.getDifficultyLevelsByPrimeMover(
          primeMoverMuscleId: TestData.primeMoverMuscleId,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('delegates the muscle groups call', () async {
      final response = await dataSource.getMusclesGroups();

      expect(fakeApiClient.callCount, 1);
      expect(response.musclesGroup, isEmpty);
    });

    test('delegates the muscles by group call', () async {
      final response = await dataSource.getMusclesByGroup('group-1');

      expect(fakeApiClient.callCount, 1);
      expect(fakeApiClient.lastMuscleGroupId, 'group-1');
      expect(response.muscles, isEmpty);
    });
  });
}
