import 'package:injectable/injectable.dart';

import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/exercise/domain/entities/difficulty_level_entity.dart';
import 'package:fitness_app/features/exercise/domain/repo/exercise_repo.dart';

@injectable
class GetDifficultyLevelsUseCase {
  final ExerciseRepo _repo;

  GetDifficultyLevelsUseCase(this._repo);

  Future<BaseResponse<List<DifficultyLevelEntity>>> call({
    required String primeMoverMuscleId,
  }) {
    return _repo.getDifficultyLevels(primeMoverMuscleId: primeMoverMuscleId);
  }
}
