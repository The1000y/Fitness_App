import '../../model/responses/exercises_list_response.dart';

abstract interface class ExerciseRemoteDataSource {
  Future<ExercisesListResponse> getExercisesByMuscleDifficulty({
    required String primeMoverMuscleId,
    required String difficultyLevelId,
  });
}
