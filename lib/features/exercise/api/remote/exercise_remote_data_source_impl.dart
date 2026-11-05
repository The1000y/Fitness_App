import 'package:fitness_app/features/exercise/api/client/exercise_api_client.dart';
import 'package:fitness_app/features/exercise/data/data_source/remote/exercise_remote_data_source.dart';
import 'package:fitness_app/features/exercise/data/model/responses/difficulty_levels_response.dart';
import 'package:fitness_app/features/exercise/data/model/responses/exercises_list_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ExerciseRemoteDataSource)
class ExerciseRemoteDataSourceImpl implements ExerciseRemoteDataSource {
  final ExerciseApiClient _apiClient;

  ExerciseRemoteDataSourceImpl(this._apiClient);

  @override
  Future<ExercisesListResponse> getExercisesByMuscleDifficulty({
    required String primeMoverMuscleId,
    required String difficultyLevelId,
  }) {
    return _apiClient.getExercisesByMuscleDifficulty(
      primeMoverMuscleId,
      difficultyLevelId,
    );
  }
  @override
Future<DifficultyLevelsResponse> getDifficultyLevelsByPrimeMover({
  required String primeMoverMuscleId,
}) {
  return _apiClient.getDifficultyLevelsByPrimeMover(primeMoverMuscleId);
}
}
