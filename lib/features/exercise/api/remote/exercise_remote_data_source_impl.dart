import 'package:fitness_app/features/exercise/api/client/exercise_api_client.dart';
import 'package:fitness_app/features/exercise/data/data_source/remote/exercise_remote_data_source.dart';
import 'package:fitness_app/features/exercise/data/model/responses/difficulty_levels_dto.dart';
import 'package:fitness_app/features/exercise/data/model/responses/exercises_list_dto.dart';
import 'package:fitness_app/features/exercise/data/model/responses/muscle_difficulty_response.dart';
import 'package:fitness_app/features/exercise/data/model/responses/muscles_by_group_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ExerciseRemoteDataSource)
class ExerciseRemoteDataSourceImpl implements ExerciseRemoteDataSource {
  final ExerciseApiClient _apiClient;

  ExerciseRemoteDataSourceImpl(this._apiClient);

  @override
  Future<ExercisesListDto> getExercisesByMuscleDifficulty({
    required String primeMoverMuscleId,
    required String difficultyLevelId,
    required int page,
    required int limit,
  }) {
    return _apiClient.getExercisesByMuscleDifficulty(
      primeMoverMuscleId,
      difficultyLevelId,
      page,
      limit,
    );
  }

  @override
  Future<DifficultyLevelsDto> getDifficultyLevelsByPrimeMover({
    required String primeMoverMuscleId,
  }) {
    return _apiClient.getDifficultyLevelsByPrimeMover(primeMoverMuscleId);
  }

  @override
  Future<MusclesByGroupResponse> getMusclesByGroup(String id) {
    // TODO: implement getMusclesByGroup
    throw UnimplementedError();
  }

  @override
  Future<MuscleGroupsResponse> getMusclesGroups() {
    // TODO: implement getMusclesGroups
    throw UnimplementedError();
  }
}
