import 'package:dio/dio.dart';
import 'package:fitness_app/core/constants/api_strings.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../data/model/responses/difficulty_levels_dto.dart';
import '../../data/model/responses/exercises_list_dto.dart';
import '../../data/model/responses/muscle_groups_response.dart';
import '../../data/model/responses/muscles_by_group_response.dart';

part 'exercise_api_client.g.dart';

@singleton
@RestApi()
abstract class ExerciseApiClient {
  @factoryMethod
  factory ExerciseApiClient(Dio dio) = _ExerciseApiClient;

  @GET(ApiStrings.exercisesByMuscleDifficulty)
  Future<ExercisesListDto> getExercisesByMuscleDifficulty(
    @Query(ApiStrings.qPrimeMoverMuscleId) String primeMoverMuscleId,
    @Query(ApiStrings.qDifficultyLevelId) String difficultyLevelId,
    @Query(ApiStrings.qPage) int page,
    @Query(ApiStrings.qLimit) int limit,
  );

  @GET(ApiStrings.difficultyLevelsByPrimeMover)
  Future<DifficultyLevelsDto> getDifficultyLevelsByPrimeMover(
    @Query(ApiStrings.qPrimeMoverMuscleId) String primeMoverMuscleId,
  );

  @GET(ApiStrings.muscles)
  Future<MuscleGroupsResponse> getMuscleGroups();

  @GET(ApiStrings.musclesByGroup)
  Future<MusclesByGroupResponse> getMusclesByGroup(
    @Query(ApiStrings.qMuscleGroupId) String muscleGroupId,
  );
}
