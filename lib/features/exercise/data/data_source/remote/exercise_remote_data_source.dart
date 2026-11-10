import 'package:fitness_app/features/exercise/data/model/responses/difficulty_levels_dto.dart';
import 'package:fitness_app/features/exercise/data/model/responses/exercises_list_dto.dart';
import 'package:fitness_app/features/exercise/data/model/responses/muscle_groups_response.dart';
import 'package:fitness_app/features/exercise/data/model/responses/muscles_by_group_response.dart';

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

  Future<MuscleGroupsResponse> getMusclesGroups();

  Future<MusclesByGroupResponse> getMusclesByGroup(String id);

  Future<MusclesByGroupResponse> getRandomMuscles();
}
