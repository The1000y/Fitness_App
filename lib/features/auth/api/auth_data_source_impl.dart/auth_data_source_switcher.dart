import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/auth/api/auth_data_source_impl.dart/remote/auth_fake_remote_data_source_impl.dart';
import 'package:fitness_app/features/auth/api/auth_data_source_impl.dart/remote/auth_remote_data_source_impl.dart';
import 'package:fitness_app/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:fitness_app/features/auth/data/model/requests/forget_password_request/forget_password_request.dart';
import 'package:fitness_app/features/auth/data/model/requests/reset_password_request/reset_password_request.dart';
import 'package:fitness_app/features/auth/data/model/requests/verify_otp_request/verify_otp_request.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRemoteDataSource)
class AuthDataSourceSwitcher implements AuthRemoteDataSource {
 final  AuthRemoteDataSourceImpl authRemoteDataSourceImpl;
 final AuthFakeRemoteDataSourceImpl authFackDataSourceImpl;
  AuthDataSourceSwitcher({
    required this.authRemoteDataSourceImpl,
    required this.authFackDataSourceImpl,
  });

  static const bool useDummyData = true;
  @override
  Future<BaseResponse<void>> forgetPassword(
    ForgetPasswordRequest forgetPasswordRequest,
  ) {
    if (useDummyData) {
      return authFackDataSourceImpl.forgetPassword(forgetPasswordRequest);
    } else {
      return authRemoteDataSourceImpl.forgetPassword(forgetPasswordRequest);
    }
  }

  @override
  Future<BaseResponse<void>> resetPassword(
    ResetPasswordRequest resetPasswordRequest,
  ) {
    if (useDummyData) {
      return authFackDataSourceImpl.resetPassword(resetPasswordRequest);
    } else {
      return authRemoteDataSourceImpl.resetPassword(resetPasswordRequest);
    }
  }

  @override
  Future<BaseResponse<void>> verifyOtp(VerifyOtpRequest verifyOtpRequest) {
    if (useDummyData) {
      return authFackDataSourceImpl.verifyOtp(verifyOtpRequest);
    } else {
      return authRemoteDataSourceImpl.verifyOtp(verifyOtpRequest);
    }
  }
}
