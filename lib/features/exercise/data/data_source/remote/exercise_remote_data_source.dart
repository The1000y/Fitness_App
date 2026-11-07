import 'package:fitness_app/features/exercise/data/model/responses/difficulty_levels_dto.dart';
import 'package:fitness_app/features/exercise/data/model/responses/exercises_list_dto.dart';

abstract interface class ExerciseRemoteDataSource {
  Future<ExercisesListDto> getExercisesByMuscleDifficulty({
    required String primeMoverMuscleId,
    required String difficultyLevelId,
    required int page,
    required int limit,
  });

  Future<DifficultyLevelsDto> getDifficultyLevelsByPrimeMover({
    required String primeMoverMuscleId,
  });
}
