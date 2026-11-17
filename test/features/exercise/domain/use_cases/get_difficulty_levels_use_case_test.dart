import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/exercise/domain/use_cases/get_difficulty_levels_use_case.dart';
import '../../../../helpers/fakes.dart';
import '../../../../helpers/test_data.dart';

void main() {
  late FakeExerciseRepo fakeRepo;
  late GetDifficultyLevelsUseCase useCase;

  setUp(() {
    fakeRepo = FakeExerciseRepo();
    useCase = GetDifficultyLevelsUseCase(fakeRepo);
  });

  group('GetDifficultyLevelsUseCase', () {
    test('forwards the prime mover id to the repository', () async {
      fakeRepo.nextLevelsResult = Success(TestData.difficultyLevelsEntity);

      final result = await useCase(
        primeMoverMuscleId: TestData.primeMoverMuscleId,
      );

      expect(fakeRepo.levelsCallCount, 1);
      expect(fakeRepo.lastPrimeMoverMuscleId, TestData.primeMoverMuscleId);
      expect(result, isA<Success<dynamic>>());
      expect((result as Success).data, TestData.difficultyLevelsEntity);
    });

    test('forwards an Error result untouched', () async {
      fakeRepo.nextLevelsResult = const Error(TimeoutFailure());

      final result = await useCase(
        primeMoverMuscleId: TestData.primeMoverMuscleId,
      );

      expect(result, isA<Error<dynamic>>());
      expect((result as Error).failure, isA<TimeoutFailure>());
    });
  });
}
