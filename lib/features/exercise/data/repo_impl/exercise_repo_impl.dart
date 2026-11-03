import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/utils/excecute_api_call.dart';
import 'package:fitness_app/features/exercise/domain/entities/exercises_list_entity.dart';
import 'package:fitness_app/features/exercise/domain/repo/exercise_repo.dart';
import 'package:injectable/injectable.dart';

import '../data_source/remote/exercise_remote_data_source.dart';

@Injectable(as: ExerciseRepo)
class ExerciseRepoImpl implements ExerciseRepo {
  final ExerciseRemoteDataSource _remote;

  ExerciseRepoImpl(this._remote);

  @override
  Future<BaseResponse<ExercisesListEntity>> getExercisesByMuscleDifficulty({
    required String primeMoverMuscleId,
    required String difficultyLevelId,
  }) {
    return excecuteApiCall(() async {
      final response = await _remote.getExercisesByMuscleDifficulty(
        primeMoverMuscleId: primeMoverMuscleId,
        difficultyLevelId: difficultyLevelId,
      );
      return response.toEntity();
    });
  }
}
