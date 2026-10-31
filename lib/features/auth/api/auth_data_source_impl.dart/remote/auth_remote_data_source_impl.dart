import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/utils/excecute_api_call.dart';
import 'package:fitness_app/features/auth/api/client/auth_api_client.dart';
import 'package:fitness_app/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:fitness_app/features/auth/data/model/requests/register_request/register_request.dart';
import 'package:fitness_app/features/auth/data/model/responces/register_request/register_response.dart';
import 'package:fitness_app/features/auth/data/model/requests/forget_password_request/forget_password_request.dart';
import 'package:fitness_app/features/auth/data/model/requests/reset_password_request/reset_password_request.dart';
import 'package:fitness_app/features/auth/data/model/requests/verify_otp_request/verify_otp_request.dart';
import 'package:injectable/injectable.dart';


@injectable
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthApiClient authApiClient;
  AuthRemoteDataSourceImpl({required this.authApiClient});

  @override
  Future<BaseResponse<RegisterResponseDto>> register(RegisterRequestDto req) {
    return excecuteApiCall(() => authApiClient.register(req));
  }

  @override
  Future<BaseResponse<void>> forgetPassword(
    ForgetPasswordRequest forgetPasswordRequest,
  ) async {
    return await excecuteApiCall(
      () => authApiClient.forgetPassword(forgetPasswordRequest),
    );
  }

  @override
  Future<BaseResponse<void>> resetPassword(
    ResetPasswordRequest resetPasswordRequest,
  ) async {
    return await excecuteApiCall(
      () => authApiClient.resetPassword(resetPasswordRequest),
    );
  }

  @override
  Future<BaseResponse<void>> verifyOtp(VerifyOtpRequest verifyOtpRequest) async {
    return await excecuteApiCall(
      () => authApiClient.verifyOtp(verifyOtpRequest),
    );
  }
}
