import 'dart:math';

import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscle_entity.dart';
import 'package:fitness_app/features/home/domain/entities/popular_training_entity.dart';
import 'package:injectable/injectable.dart';

import '../../../exercise/domain/repo/exercise_repo.dart';

@injectable
class GetPopularTrainingUseCase {
  static const int _maxMuscles = 5;

  final ExerciseRepo _repo;

  GetPopularTrainingUseCase(this._repo);

  Future<BaseResponse<List<PopularTrainingEntity>>> call({
    required List<MuscleEntity> muscles,
    Random? random,
  }) async {
    final rng = random ?? Random();

    final results = await Future.wait(
      muscles.take(_maxMuscles).map((muscle) => _buildForMuscle(muscle, rng)),
    );

    final trainings = <PopularTrainingEntity>[];
    for (final result in results) {
      switch (result) {
        case Success():
          final training = result.data;
          if (training != null) trainings.add(training);
        case Error():
          return Error<List<PopularTrainingEntity>>(result.failure);
      }
    }
    return Success<List<PopularTrainingEntity>>(trainings);
  }

  Future<BaseResponse<PopularTrainingEntity?>> _buildForMuscle(
    MuscleEntity muscle,
    Random random,
  ) async {
    final levelsResult = await _repo.getDifficultyLevels(
      primeMoverMuscleId: muscle.id,
    );
    switch (levelsResult) {
      case Error():
        return Error<PopularTrainingEntity?>(levelsResult.failure);
      case Success():
        final levels = levelsResult.data;
        if (levels.isEmpty) return const Success<PopularTrainingEntity?>(null);

        final level = levels[random.nextInt(levels.length)];

        final totalResult = await _repo.getTotalExercisesByMuscleDifficulty(
          muscleId: muscle.id,
          difficultyLevelId: level.id,
        );

        switch (totalResult) {
          case Error():
            return Error<PopularTrainingEntity?>(totalResult.failure);
          case Success():
            return Success<PopularTrainingEntity?>(
              PopularTrainingEntity(
                muscleId: muscle.id,
                muscleName: muscle.name,
                difficultyLevelId: level.id,
                difficultyLevelName: level.name,
                totalExercises: totalResult.data,
                muscleImage: muscle.image,
              ),
            );
        }
    }
  }
}
