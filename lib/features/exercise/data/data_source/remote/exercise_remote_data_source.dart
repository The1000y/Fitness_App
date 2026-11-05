import 'package:fitness_app/features/exercise/data/model/responses/difficulty_levels_response.dart';
import '../../model/responses/exercises_list_response.dart';

abstract interface class ExerciseRemoteDataSource {
  Future<ExercisesListResponse> getExercisesByMuscleDifficulty({
    required String primeMoverMuscleId,
    required String difficultyLevelId,
  });
  Future<DifficultyLevelsResponse> getDifficultyLevelsByPrimeMover({
  required String primeMoverMuscleId,
});
}
