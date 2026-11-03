import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/exercise/domain/use_cases/get_exercises_use_case.dart';
import '../../../../helpers/fakes.dart';
import '../../../../helpers/test_data.dart';

void main() {
  late FakeExerciseRepo fakeRepo;
  late GetExercisesUseCase useCase;

  setUp(() {
    fakeRepo = FakeExerciseRepo();
    useCase = GetExercisesUseCase(fakeRepo);
  });

  group('GetExercisesUseCase', () {
    test('forwards both ids to the repository', () async {
      fakeRepo.nextResult = Success(TestData.exercisesListEntity);

      final result = await useCase(
        primeMoverMuscleId: TestData.primeMoverMuscleId,
        difficultyLevelId: TestData.difficultyLevelId,
      );

      expect(fakeRepo.callCount, 1);
      expect(fakeRepo.lastPrimeMoverMuscleId, TestData.primeMoverMuscleId);
      expect(fakeRepo.lastDifficultyLevelId, TestData.difficultyLevelId);
      expect(result, isA<Success<dynamic>>());
      expect((result as Success).data, TestData.exercisesListEntity);
    });

    test('forwards an Error result untouched', () async {
      fakeRepo.nextResult = const Error(TimeoutFailure());

      final result = await useCase(
        primeMoverMuscleId: TestData.primeMoverMuscleId,
        difficultyLevelId: TestData.difficultyLevelId,
      );

      expect(result, isA<Error<dynamic>>());
      expect((result as Error).failure, isA<TimeoutFailure>());
    });
  });
}
