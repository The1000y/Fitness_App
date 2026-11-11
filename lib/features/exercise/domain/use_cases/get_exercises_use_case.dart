import 'package:injectable/injectable.dart';

import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/exercise/domain/entities/exercises_list_entity.dart';
import 'package:fitness_app/features/exercise/domain/repo/exercise_repo.dart';

@injectable
class GetExercisesUseCase {
  final ExerciseRepo _repo;

  GetExercisesUseCase(this._repo);

  Future<BaseResponse<ExercisesListEntity>> call({
    required String primeMoverMuscleId,
    required String difficultyLevelId,
    required int page,
    required int limit,
  }) {
    return _repo.getExercisesByMuscleDifficulty(
      primeMoverMuscleId: primeMoverMuscleId,
      difficultyLevelId: difficultyLevelId,
      page: page,
      limit: limit,
    );
  }
}
