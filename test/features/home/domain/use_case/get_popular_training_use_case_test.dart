import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscle_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/difficulty_level_entity.dart';
import 'package:fitness_app/features/home/domain/use_case/get_popular_training_use_case.dart';
import '../../../../helpers/fakes.dart';

void main() {
  late FakeExerciseRepo fakeRepo;
  late GetPopularTrainingUseCase useCase;

  setUp(() {
    fakeRepo = FakeExerciseRepo();
    useCase = GetPopularTrainingUseCase(fakeRepo);
  });

  group('GetPopularTrainingUseCase', () {
    test('returns popular training list successfully', () async {
      fakeRepo.nextLevelsResult = const Success([
        DifficultyLevelEntity(id: 'diff-1', name: 'Beginner'),
      ]);
      fakeRepo.nextTotalExercisesResult = const Success(5);

      const muscle = MuscleEntity(id: 'muscle-1', name: 'Chest', image: 'url');

      final result = await useCase(muscles: [muscle], random: Random(1));

      expect(result, isA<Success<dynamic>>());
      final trainings = (result as Success).data;
      expect(trainings.length, 1);
      expect(trainings.first.muscleId, 'muscle-1');
      expect(trainings.first.muscleName, 'Chest');
      expect(trainings.first.totalExercises, 5);
      expect(trainings.first.difficultyLevelId, 'diff-1');
    });

    test('returns error when difficulty levels fail', () async {
      fakeRepo.nextLevelsResult = const Error(TimeoutFailure());

      const muscle = MuscleEntity(id: 'muscle-1', name: 'Chest', image: 'url');

      final result = await useCase(muscles: [muscle]);

      expect(result, isA<Error<dynamic>>());
      expect((result as Error).failure, isA<TimeoutFailure>());
    });
  });
}
