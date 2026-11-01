import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscles_by_group_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscles_entity.dart';

abstract class ExerciseRepo {
  Future<BaseResponse<MusclesByGroupEntity>> getMusclesGroups();

  Future<BaseResponse<MusclesEntity>> getMusclesByGroup({
    required String id,
  });
}