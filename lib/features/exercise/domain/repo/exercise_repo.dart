import 'package:fitness_app/features/exercise/domain/entities/difficulty_level_entity.dart';

import '../../../../config/base/base_response.dart';
import '../entities/exercises_list_entity.dart';

abstract interface class ExerciseRepo {
  Future<BaseResponse<ExercisesListEntity>> getExercisesByMuscleDifficulty({
    required String primeMoverMuscleId,
    required String difficultyLevelId,
    required int page,
    required int limit,
  });

  Future<BaseResponse<List<DifficultyLevelEntity>>> getDifficultyLevels({
    required String primeMoverMuscleId,
  });
}
