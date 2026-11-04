import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/utils/excecute_api_call.dart';
import 'package:fitness_app/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscles_entity.dart';
import 'package:fitness_app/features/home/data/data_source/local/home_local_data_source.dart';
import 'package:fitness_app/features/home/data/data_source/remote/home_remote_data_source.dart';
import 'package:fitness_app/features/home/domain/repo/home_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: HomeRepo)
class HomeRepoImpl implements HomeRepo {
  final HomeRemoteDataSource _remote;
  final HomeLocalDataSource _local;

  HomeRepoImpl(this._remote, this._local);

  @override
  Future<BaseResponse<MusclesEntity>> getRandomMuscles() {
    return excecuteApiCall(() async {
      final response = await _remote.getRandomMuscles();
      return response.toEntity();
    });
  }

  @override
  Future<BaseResponse<UserEntity>> getCurrentUser() {
    return excecuteApiCall(() async {
      final user = await _local.getCachedUser();
      return user?.toEntity() ?? const UserEntity();
    });
  }
}