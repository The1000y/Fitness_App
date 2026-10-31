import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/auth/api/auth_data_source_impl.dart/remote/auth_fake_remote_data_source_impl.dart';
import 'package:fitness_app/features/auth/data/model/requests/forget_password_request/forget_password_request.dart';
import 'package:fitness_app/features/auth/data/model/requests/reset_password_request/reset_password_request.dart';
import 'package:fitness_app/features/auth/data/model/requests/verify_otp_request/verify_otp_request.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AuthFakeRemoteDataSourceImpl localDataSource;

  setUp(() {
    localDataSource = AuthFakeRemoteDataSourceImpl();
  });

  group('AuthLocalDataSourceImpl', () {
    group('forgetPassword', () {
      test('returns Error with UnknownFailure when email is error@test.com', () async {
        final result = await localDataSource.forgetPassword(
          ForgetPasswordRequest(email: 'error@test.com'),
        );

        expect(result, isA<Error<void>>());
        final error = result as Error<void>;
        expect(error.failure, isA<UnknownFailure>());
      });

      test('returns Success when email is not error@test.com', () async {
        final result = await localDataSource.forgetPassword(
          ForgetPasswordRequest(email: 'success@test.com'),
        );

        expect(result, isA<Success<void>>());
      });
    });

    group('verifyOtp', () {
      test('returns Error with UnknownFailure when resetCode is 0000', () async {
        final result = await localDataSource.verifyOtp(
          VerifyOtpRequest(resetCode: '0000'),
        );

        expect(result, isA<Error<void>>());
        final error = result as Error<void>;
        expect(error.failure, isA<UnknownFailure>());
      });

      test('returns Success when resetCode is valid', () async {
        final result = await localDataSource.verifyOtp(
          VerifyOtpRequest(resetCode: '1234'),
        );

        expect(result, isA<Success<void>>());
      });
    });

    group('resetPassword', () {
      test('returns Error with UnknownFailure when newPassword is 0000', () async {
        final result = await localDataSource.resetPassword(
          ResetPasswordRequest(email: 'test@example.com', newPassword: '0000'),
        );

        expect(result, isA<Error<void>>());
        final error = result as Error<void>;
        expect(error.failure, isA<UnknownFailure>());
      });

      test('returns Success when newPassword is valid', () async {
        final result = await localDataSource.resetPassword(
          ResetPasswordRequest(email: 'test@example.com', newPassword: 'Password123!'),
        );

        expect(result, isA<Success<void>>());
      });
    });
  });
}
