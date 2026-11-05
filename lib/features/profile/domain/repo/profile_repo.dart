import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/profile/domain/entities/params/change_password_param.dart';

abstract interface class ProfileRepo {
  Future<BaseResponse<void>> changePassword(ChangePasswordParam param);
}
