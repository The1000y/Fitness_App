import 'package:injectable/injectable.dart';

import '../../../../config/base/base_response.dart';
import '../entities/difficulty_level_entity.dart';
import '../repo/exercise_repo.dart';

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
