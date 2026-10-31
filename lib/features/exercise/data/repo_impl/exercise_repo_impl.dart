
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/utils/excecute_api_call.dart';
import 'package:fitness_app/features/exercise/data/data_source/remote/exercise_remote_data_source.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscles_by_group_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscles_entity.dart';
import 'package:fitness_app/features/exercise/domain/repo/exercise_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ExerciseRepo)
class ExerciseRepoImpl implements ExerciseRepo {
  final ExerciseRemoteDataSource _remote;

  ExerciseRepoImpl(this._remote);

  @override
  Future<BaseResponse<MusclesEntity>> getMusclesByGroup({
    required String id,
  }) async {
    return await excecuteApiCall(() async {
      final response = await _remote.getMusclesByGroup(id);
      return response.toEntity();
    });
  }

  @override
  Future<BaseResponse<MusclesByGroupEntity>> getMusclesGroups() async {
    return await excecuteApiCall(() async {
      final response = await _remote.getMusclesGroups();
      return response.toEntity();
    });
  }
}
