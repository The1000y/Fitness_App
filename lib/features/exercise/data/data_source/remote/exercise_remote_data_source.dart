
import 'package:fitness_app/features/exercise/data/model/responses/muscles_by_group_response.dart';
import 'package:fitness_app/features/exercise/data/model/responses/muscle_groups_response.dart';

abstract interface class ExerciseRemoteDataSource {
  Future<MuscleGroupsResponse> getMusclesGroups();

  Future<MusclesByGroupResponse> getMusclesByGroup(
    String id,
  );
}
