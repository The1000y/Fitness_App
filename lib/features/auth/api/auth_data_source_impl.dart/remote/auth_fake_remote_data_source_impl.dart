import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:fitness_app/features/auth/data/model/requests/forget_password_request/forget_password_request.dart';
import 'package:fitness_app/features/auth/data/model/requests/register_request/register_request.dart';
import 'package:fitness_app/features/auth/data/model/requests/reset_password_request/reset_password_request.dart';
import 'package:fitness_app/features/auth/data/model/requests/verify_otp_request/verify_otp_request.dart';
import 'package:fitness_app/features/auth/data/model/responces/register_request/register_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthFakeRemoteDataSourceImpl implements AuthRemoteDataSource {
  static const _errorEmail = 'error@test.com';
static const _invalidOtp = '0000';

  @override
  Future<BaseResponse<RegisterResponseDto>> register(RegisterRequestDto req) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return Error<RegisterResponseDto>(const UnknownFailure());
  }

  @override
  Future<BaseResponse<void>> forgetPassword(
    ForgetPasswordRequest forgetPasswordRequest,
  ) async {
    // محاكاة وقت انتظار السيرفر (Network Delay)
    await Future.delayed(const Duration(milliseconds: 800));

    // تجربة لاختبار الخطأ لو الإيميل مش موجود مثلاً
    if (forgetPasswordRequest.email ==_errorEmail) {
      return Error<void>(const UnknownFailure());
    }

    // إرجاع BaseResponse وهمي ناجح
    return Success<void>(null);
  }

  @override
  Future<BaseResponse<void>> verifyOtp(
    VerifyOtpRequest verifyOtpRequest,
  ) async {
    await Future.delayed(const Duration(milliseconds: 800));

    // لو حابب تختبر كود خطأ (مثلاً لو الكود 0000 اعتبره غلط)
      if (verifyOtpRequest.resetCode == _invalidOtp) {
      return Error<void>(const UnknownFailure());
    }

    // إرجاع BaseResponse وهمي ناجح
    return Success<void>(null);
  }

  @override
  Future<BaseResponse<void>> resetPassword(
    ResetPasswordRequest resetPasswordRequest,
  ) async {
    await Future.delayed(const Duration(milliseconds: 800));

        if (resetPasswordRequest.newPassword == _invalidOtp) {
      return Error<void>(const UnknownFailure());
    }

    // إرجاع BaseResponse وهمي ناجح
    return Success<void>(null);
  }
  }
