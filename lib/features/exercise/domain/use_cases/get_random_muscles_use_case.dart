import 'package:fitness_app/config/base/base_response.dart';
import 'package:injectable/injectable.dart';

import '../entities/muscles_by_group_entity.dart';
import '../repo/exercise_repo.dart';

@injectable
class GetRandomMusclesUseCase {
  final ExerciseRepo _repo;

  GetRandomMusclesUseCase(this._repo);

  Future<BaseResponse<MusclesByGroupEntity>> call() {
    return _repo.getRandomMuscles();
  }
}
