import 'package:dio/dio.dart';
import 'package:fitness_app/core/constants/api_strings.dart';
import 'package:fitness_app/features/auth/data/model/requests/forget_password_request/forget_password_request.dart';
import 'package:fitness_app/features/auth/data/model/requests/reset_password_request/reset_password_request.dart';
import 'package:fitness_app/features/auth/data/model/requests/verify_otp_request/verify_otp_request.dart';
import 'package:fitness_app/features/auth/data/model/requests/register_request/register_request.dart';
import 'package:fitness_app/features/auth/data/model/responces/register_request/register_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'auth_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class AuthApiClient {
  @factoryMethod
  factory AuthApiClient(Dio dio) = _AuthApiClient;

  @POST(ApiStrings.signup)
  Future<RegisterResponseDto> register(@Body() RegisterRequestDto request);

  @POST(ApiStrings.forgotPassword)
  Future<void> forgetPassword(@Body() ForgetPasswordRequest requestEmail);
  @POST(ApiStrings.resetPassword)
  Future<void> resetPassword(@Body() ResetPasswordRequest params);
  @POST(ApiStrings.verifyResetCode)
  Future<void> verifyOtp(@Body() VerifyOtpRequest params);
}
