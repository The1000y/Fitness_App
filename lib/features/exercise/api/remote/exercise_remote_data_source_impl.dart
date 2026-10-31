import 'package:fitness_app/features/exercise/api/client/exercise_api_client.dart';
import 'package:fitness_app/features/exercise/data/data_source/remote/exercise_remote_data_source.dart';
import 'package:fitness_app/features/exercise/data/model/responses/muscles_by_group_response.dart';
import 'package:fitness_app/features/exercise/data/model/responses/muscles_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ExerciseRemoteDataSource)
class ExerciseRemoteDataSourceImpl implements ExerciseRemoteDataSource {
  final ExerciseApiClient _exerciseApiClient;
  ExerciseRemoteDataSourceImpl(this._exerciseApiClient);

  @override
  Future<MusclesByGroupResponse> getMusclesByGroup(String id) {
    return _exerciseApiClient.getMusclesByGroup(id);
  }

  @override
  Future<MusclesResponse> getMusclesGroups() {
    return _exerciseApiClient.getMuscles();
  }
}
