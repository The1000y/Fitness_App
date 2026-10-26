import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:fitness_app/features/auth/data/model/requests/forget_password_request/forget_password_request.dart';
import 'package:fitness_app/features/auth/data/model/requests/reset_password_request/reset_password_request.dart';
import 'package:fitness_app/features/auth/data/model/requests/verify_otp_request/verify_otp_request.dart';
import 'package:fitness_app/features/auth/domain/entities/params/forget_password_param.dart';
import 'package:fitness_app/features/auth/domain/entities/params/reset_password_param.dart';
import 'package:fitness_app/features/auth/domain/entities/params/verify_otp_param.dart';
import 'package:fitness_app/features/auth/domain/repo/auth_repo.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepo)
class AuthRepositoryImpl implements AuthRepo {
  final AuthRemoteDataSource _remoteDataSource;

  const AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<void>> forgetPassword(
    ForgetPasswordParam forgetPasswordParam,
  ) async {
    final request = ForgetPasswordRequest(email: forgetPasswordParam.email);
    var response = await _remoteDataSource.forgetPassword(request);
    switch (response) {
      case Success<void>():
        return Success<void>(null);
      case Error<void>():
        return Error<void>(response.failure);
    }
  }

  @override
  Future<BaseResponse<void>> verifyOtp(VerifyOtpParam verifyOtpParam) async {
    final request = VerifyOtpRequest(resetCode: verifyOtpParam.resetCode);
    final response = await _remoteDataSource.verifyOtp(request);
    switch (response) {
      case Success<void>():
        return Success<void>(null);
      case Error<void>():
        return Error<void>(response.failure);
    }
  }

  @override
  Future<BaseResponse<void>> resetPassword(
    ResetPasswordParam resetPasswordParam,
  ) async {
    final request = ResetPasswordRequest(
      email: resetPasswordParam.email,
      newPassword: resetPasswordParam.password,
    );
    final response = await _remoteDataSource.resetPassword(request);
    switch (response) {
      case Success<void>():
        return Success<void>(null);
      case Error<void>():
        return Error<void>(response.failure);
    }
  }
}
