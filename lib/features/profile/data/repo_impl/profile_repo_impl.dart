import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/core/constants/storage_keys.dart';
import 'package:fitness_app/features/profile/data/data_source/remote/profile_remote_data_source.dart';
import 'package:fitness_app/features/profile/data/model/requests/change_password_request.dart';
import 'package:fitness_app/features/profile/domain/entities/params/change_password_param.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_entity.dart';
import 'package:fitness_app/features/profile/domain/repo/profile_repo.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProfileRepo)
class ProfileRepoImpl implements ProfileRepo {
  final ProfileRemoteDataSource _remoteDataSource;
  final FlutterSecureStorage _storage;

  const ProfileRepoImpl(this._remoteDataSource, this._storage);

  @override
  Future<BaseResponse<void>> changePassword(ChangePasswordParam param) async {
    final response = await _remoteDataSource.changePassword(
      ChangePasswordRequest(
        password: param.oldPassword,
        newPassword: param.newPassword,
      ),
    );
    return response;
  }

  @override
  Future<BaseResponse<ProfileEntity>> getProfile() async {
    final response = await _remoteDataSource.getProfile();
    return switch (response) {
      Success(:final data) => Success<ProfileEntity>(data.toEntity()),
      Error(:final failure) => Error<ProfileEntity>(failure),
    };
  }

  @override
  Future<BaseResponse<void>> logout() async {
    final response = await _remoteDataSource.logout();
     await Future.wait([
        _storage.delete(key: StorageKeys.kUserToken),
        _storage.delete(key: StorageKeys.kUserData),
        _storage.delete(key: StorageKeys.kRefreshToken),
      ]);
    return response;
  }
}
