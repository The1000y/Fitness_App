import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/config/utils/excecute_api_call.dart';
import 'package:fitness_app/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:fitness_app/features/auth/data/model/requests/forget_password_request/forget_password_request.dart';
import 'package:fitness_app/features/auth/data/model/requests/login_request/login_request.dart';
import 'package:fitness_app/features/auth/data/model/requests/register_request/register_request_mapper.dart';
import 'package:fitness_app/features/auth/data/model/requests/reset_password_request/reset_password_request.dart';
import 'package:fitness_app/features/auth/data/model/requests/verify_otp_request/verify_otp_request.dart';
import 'package:fitness_app/features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:fitness_app/features/auth/domain/entities/params/forget_password_param.dart';
import 'package:fitness_app/features/auth/domain/entities/params/register_params_entity.dart';
import 'package:fitness_app/features/auth/domain/entities/params/reset_password_param.dart';
import 'package:fitness_app/features/auth/domain/entities/params/verify_otp_param.dart';
import 'package:fitness_app/features/auth/domain/entities/register_entity/register_response_entity.dart';
import 'package:fitness_app/features/auth/domain/repo/auth_repo.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/login_entity/user_entity.dart';
import '../data_source/current_user_holder.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final RemoteDataSource _remote;
  final AuthRemoteDataSource _remoteDataSource;
  final CurrentUserHolder _userHolder;

  AuthRepoImpl(this._remote, this._remoteDataSource, this._userHolder);

  @override
  Future<BaseResponse<LoginEntity>> login({
    required String email,
    required String password,
  }) async {
    final result = await excecuteApiCall(() async {
      final response = await _remote.login(
        LoginRequest(email: email, password: password),
      );
      return response.toEntity();
    });
    if (result case Success(:final data) when data.token.isNotEmpty) {
      _userHolder.user = data.user;
    }

    return switch (result) {
      Success(:final data) when data.token.isEmpty => const Error<LoginEntity>(
        ServerFailure(),
      ),
      _ => result,
    };
  }

  @override
  Future<BaseResponse<UserEntity>> getCurrentUser() async {
    final user = _userHolder.user;
    if (user == null) return const Error<UserEntity>(UnauthorizedFailure());
    return Success<UserEntity>(user);
  }

  @override
  Future<BaseResponse<RegisterResponeEntity>> register(
    RegisterParams params,
  ) async {
    final response = await _remoteDataSource.register(params.toDto());
    return switch (response) {
      Success(:final data) => Success(data.toEntity()),
      Error(:final failure) => Error(failure),
    };
  }

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

typedef AuthRepositoryImpl = AuthRepoImpl;
