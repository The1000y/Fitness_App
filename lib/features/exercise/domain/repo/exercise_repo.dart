import '../../../../config/base/base_response.dart';
import '../entities/exercises_list_entity.dart';

abstract interface class ExerciseRepo {
  Future<BaseResponse<ExercisesListEntity>> getExercisesByMuscleDifficulty({
    required String primeMoverMuscleId,
    required String difficultyLevelId,
  });
}
