import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/profile/data/data_source/remote/profile_remote_data_source.dart';
import 'package:fitness_app/features/profile/data/model/requests/change_password_request.dart';
import 'package:fitness_app/features/profile/domain/entities/params/change_password_param.dart';
import 'package:fitness_app/features/profile/domain/repo/profile_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProfileRepo)
class ProfileRepoImpl implements ProfileRepo {
  final ProfileRemoteDataSource _remoteDataSource;

  const ProfileRepoImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<void>> changePassword(ChangePasswordParam param) async {
    final response = await _remoteDataSource.changePassword(
      ChangePasswordRequest(
        password: param.oldPassword,
        newPassword: param.newPassword,
      ),
    );
    return switch (response) {
      Success<void>() => const Success<void>(null),
      Error<void>(:final failure) => Error<void>(failure),
    };
  }
}
