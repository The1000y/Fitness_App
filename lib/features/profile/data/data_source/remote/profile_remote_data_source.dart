import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/profile/data/model/requests/change_password_request.dart';

abstract interface class ProfileRemoteDataSource {
  Future<BaseResponse<void>> changePassword(ChangePasswordRequest request);
}
