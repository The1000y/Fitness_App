import 'dart:developer' as developer;

import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/di/di.dart';
import 'package:fitness_app/features/app/presentation/cubit/locale/app_locale_cubit.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscle_entity.dart';
import 'package:fitness_app/features/home/domain/entities/popular_training_entity.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:injectable/injectable.dart';

import '../../../exercise/domain/repo/exercise_repo.dart';
import '../services/random_service.dart';

@injectable
class GetPopularTrainingUseCase {
  static const int _maxMuscles = 5;

  final ExerciseRepo _repo;
  final RandomService _randomService;
  GetPopularTrainingUseCase(this._repo, this._randomService);


  Future<BaseResponse<List<PopularTrainingEntity>>> call({
    required List<MuscleEntity> muscles,
  }) async {
    final selectedMuscles = muscles.take(_maxMuscles).toList();

    final results = await Future.wait(
      selectedMuscles.map(_buildForMuscle),
    );

    final trainings = <PopularTrainingEntity>[];
    Error<List<PopularTrainingEntity>>? firstError;
    var successfulOperations = 0;

    for (var i = 0; i < results.length; i++) {
      final result = results[i];

      switch (result) {
        case Success():
          successfulOperations++;

          final training = result.data;
          if (training != null) {
            trainings.add(training);
          }

        case Error():
          firstError ??= Error<List<PopularTrainingEntity>>(
            result.failure,
          );

          final l10n = lookupAppLocalizations(getIt<AppLocaleCubit>().state);
          developer.log(
            l10n.failedToBuildPopularTraining(selectedMuscles[i].name),
            name: 'GetPopularTrainingUseCase', //logger not hard coding logger
            error: result.failure,
          );
      }
    }

    if (successfulOperations == 0 && firstError != null) {
      return firstError;
    }

    return Success<List<PopularTrainingEntity>>(trainings);
  }

  Future<BaseResponse<PopularTrainingEntity?>> _buildForMuscle(
    MuscleEntity muscle,
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

        final level = levels[_randomService.nextInt(levels.length)];

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
