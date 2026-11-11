import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscles_by_group_entity.dart';
import 'package:fitness_app/features/exercise/domain/repo/exercise_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetMusclesByGroupUseCase {
  final ExerciseRepo _repo;

  GetMusclesByGroupUseCase(this._repo);

  Future<BaseResponse<MusclesByGroupEntity>> call({
    required String id,
  }) {
    return _repo.getMusclesByGroup(id: id);
  }
}