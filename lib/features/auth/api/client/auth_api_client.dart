import 'package:dio/dio.dart';
import 'package:fitness_app/core/constants/api_strings.dart';
import 'package:fitness_app/features/auth/data/model/requests/forget_password_request/forget_password_request.dart';
import 'package:fitness_app/features/auth/data/model/requests/reset_password_request/reset_password_request.dart';
import 'package:fitness_app/features/auth/data/model/requests/verify_otp_request/verify_otp_request.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class AuthApiClient {
  @factoryMethod
  factory AuthApiClient(Dio dio) = _AuthApiClient;

  @POST(ApiStrings.forgotPassword)
  Future<void> forgetPassword(@Body() ForgetPasswordRequest requestEmail);
  @POST(ApiStrings.resetPassword)
  Future<void> resetPassword(@Body() ResetPasswordRequest params);
  @POST(ApiStrings.verifyResetCode)
  Future<void> verifyOtp(@Body() VerifyOtpRequest params);
}
