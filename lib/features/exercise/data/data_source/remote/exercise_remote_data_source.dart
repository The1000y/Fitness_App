
import 'package:fitness_app/features/exercise/data/model/responses/muscles_by_group_response.dart';
import 'package:fitness_app/features/exercise/data/model/responses/muscles_response.dart';

abstract interface class ExerciseRemoteDataSource {
  Future<MusclesResponse> getMusclesGroups();

  Future<MusclesByGroupResponse> getMusclesByGroup(
    String id,
  );
}
