
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscles_by_group_entity.dart';
import 'package:fitness_app/features/exercise/domain/repo/exercise_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetMuscleGroupsUseCase {
  final ExerciseRepo _repo;

  GetMuscleGroupsUseCase(this._repo);

  Future<BaseResponse<MusclesByGroupEntity>> call() {
    return _repo.getMusclesGroups();
  }
}
