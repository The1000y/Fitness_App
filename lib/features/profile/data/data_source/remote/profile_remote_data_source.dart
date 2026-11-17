import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/profile/data/model/requests/change_password_request.dart';
import 'package:fitness_app/features/profile/data/model/responses/profile_response_dto.dart';

import '../../model/requests/profile_update_request.dart';

abstract interface class ProfileRemoteDataSource {
  Future<BaseResponse<void>> changePassword(ChangePasswordRequest request);

  Future<BaseResponse<ProfileResponseDto>> getProfile();

  Future<BaseResponse<void>> logout();

  Future<BaseResponse<ProfileResponseDto>> updateProfile(ProfileUpdateRequest request);

  Future<BaseResponse<void>> uploadPhoto(String photoPath);
}
