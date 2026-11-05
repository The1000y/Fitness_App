import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import '../../data/model/responses/exercises_list_response.dart';
import '../../data/model/responses/difficulty_levels_response.dart';

part 'exercise_api_client.g.dart';

@singleton
@RestApi()
abstract class ExerciseApiClient {
  @factoryMethod
  factory ExerciseApiClient(Dio dio) = _ExerciseApiClient;

  @GET('/exercises/by-muscle-difficulty')
  Future<ExercisesListResponse> getExercisesByMuscleDifficulty(
    @Query('primeMoverMuscleId') String primeMoverMuscleId,
    @Query('difficultyLevelId') String difficultyLevelId,
  );
  @GET('/levels/difficulty-levels/by-prime-mover')
  Future<DifficultyLevelsResponse> getDifficultyLevelsByPrimeMover(
    @Query('primeMoverMuscleId') String primeMoverMuscleId,
  );
}
