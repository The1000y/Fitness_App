import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscle_groups_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscles_by_group_entity.dart';

abstract interface class ExerciseRepo {
  Future<BaseResponse<MuscleGroupsEntity>> getMusclesGroups();

  Future<BaseResponse<MusclesByGroupEntity>> getMusclesByGroup({
    required String id,
  });
}