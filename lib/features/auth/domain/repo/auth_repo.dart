import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/auth/domain/entities/params/register_params_entity.dart';
import 'package:fitness_app/features/auth/domain/entities/register_entity/register_response_entity.dart';
import 'package:fitness_app/features/auth/domain/entities/params/forget_password_param.dart';
import 'package:fitness_app/features/auth/domain/entities/params/reset_password_param.dart';
import 'package:fitness_app/features/auth/domain/entities/params/verify_otp_param.dart';

abstract interface class AuthRepo {
  Future<BaseResponse<RegisterResponeEntity>> register(RegisterParams params);
  Future<BaseResponse<void>> forgetPassword(ForgetPasswordParam email);
  Future<BaseResponse<void>> resetPassword(ResetPasswordParam restPassword);
  Future<BaseResponse<void>> verifyOtp(VerifyOtpParam verifyOtp);
}
