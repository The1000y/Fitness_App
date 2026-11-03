
import 'package:dio/dio.dart';
import 'package:fitness_app/core/constants/api_strings.dart';
import 'package:fitness_app/features/exercise/data/model/responses/muscle_groups_response.dart';
import 'package:fitness_app/features/exercise/data/model/responses/muscles_by_group_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'exercise_api_client.g.dart';

@singleton
@RestApi()
abstract class ExerciseApiClient {
  @factoryMethod
  factory ExerciseApiClient(Dio dio) = _ExerciseApiClient;

  @GET(ApiStrings.muscles)
  Future<MuscleGroupsResponse> getMuscleGroups();

  @GET(ApiStrings.musclesByGroup)
  Future<MusclesByGroupResponse> getMusclesByGroup(
    @Query(ApiStrings.qMuscleGroupId) String muscleGroupId,
  );
}
