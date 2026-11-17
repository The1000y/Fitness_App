import 'package:dio/dio.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/utils/excecute_api_call.dart';
import 'package:fitness_app/features/profile/api/client/profile_api_client.dart';
import 'package:fitness_app/features/profile/data/data_source/remote/profile_remote_data_source.dart';
import 'package:fitness_app/features/profile/data/model/requests/change_password_request.dart';
import 'package:fitness_app/features/profile/data/model/responses/profile_response_dto.dart';
import 'package:injectable/injectable.dart';

import '../../../data/model/requests/profile_update_request.dart';

@Injectable(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ProfileApiClient _profileApiClient;

  const ProfileRemoteDataSourceImpl(this._profileApiClient);

  @override
  Future<BaseResponse<void>> changePassword(ChangePasswordRequest request) {
    return excecuteApiCall(() => _profileApiClient.changePassword(request));
  }

  @override
  Future<BaseResponse<ProfileResponseDto>> getProfile() {
    return excecuteApiCall(() => _profileApiClient.getProfile());
  }

  @override
  Future<BaseResponse<void>> logout() {
    return excecuteApiCall(() => _profileApiClient.logout());
  }

  @override
  Future<BaseResponse<ProfileResponseDto>> updateProfile(
      ProfileUpdateRequest request,) {
    return excecuteApiCall(() => _profileApiClient.updateProfile(request));
  }

  @override
  Future<BaseResponse<void>> uploadPhoto(String photoPath) {
    return excecuteApiCall(() async {
      final photo = await MultipartFile.fromFile(
        photoPath,
        filename: photoPath.split(RegExp(r'[/\\]')).last,
      );
      return _profileApiClient.uploadPhoto(photo);
    });
  }
}
