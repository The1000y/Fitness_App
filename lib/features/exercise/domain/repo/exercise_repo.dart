import 'package:fitness_app/features/exercise/domain/entities/difficulty_level_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscle_groups_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscles_by_group_entity.dart';

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

  Future<BaseResponse<MuscleGroupsEntity>> getMusclesGroups();

  Future<BaseResponse<MusclesByGroupEntity>> getMusclesByGroup({
    required String id,
  });

  Future<BaseResponse<MusclesByGroupEntity>> getRandomMuscles();

  Future<BaseResponse<int>> getTotalExercisesByMuscleDifficulty({
    required String muscleId,
    required String difficultyLevelId,
  });
}
