import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/auth/data/model/requests/register_request/register_request.dart';
import 'package:fitness_app/features/auth/data/model/responces/register_request/register_response.dart';
import 'package:fitness_app/features/auth/data/model/requests/forget_password_request/forget_password_request.dart';
import 'package:fitness_app/features/auth/data/model/requests/reset_password_request/reset_password_request.dart';
import 'package:fitness_app/features/auth/data/model/requests/verify_otp_request/verify_otp_request.dart';


abstract interface class AuthRemoteDataSource {
  Future<BaseResponse<RegisterResponseDto>> register(RegisterRequestDto req);
  Future<BaseResponse<void>> forgetPassword(ForgetPasswordRequest forgetPasswordRequest);
  Future<BaseResponse<void>> resetPassword(ResetPasswordRequest resetPasswordRequest);
  Future<BaseResponse<void>> verifyOtp(VerifyOtpRequest verifyOtpRequest);
}
