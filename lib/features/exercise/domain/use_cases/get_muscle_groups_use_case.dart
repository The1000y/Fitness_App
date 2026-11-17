import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscle_groups_entity.dart';
import 'package:fitness_app/features/exercise/domain/repo/exercise_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetMuscleGroupsUseCase {
  final ExerciseRepo _repo;

  GetMuscleGroupsUseCase(this._repo);

  Future<BaseResponse<MuscleGroupsEntity>> call() async {
    final result = await _repo.getMusclesGroups();
    switch (result) {
      case Success():
        final seen = <String>{};
        final groups = result.data.musclesGroup
            .where((group) => seen.add(group.name))
            .toList();
        return Success(
          MuscleGroupsEntity(
            message: result.data.message,
            musclesGroup: groups,
          ),
        );
      case Error():
        return result;
    }
  }
}
