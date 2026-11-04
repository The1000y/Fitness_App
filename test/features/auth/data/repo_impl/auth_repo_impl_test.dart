import 'package:dio/dio.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:fitness_app/features/auth/data/model/requests/forget_password_request/forget_password_request.dart';
import 'package:fitness_app/features/auth/data/model/requests/reset_password_request/reset_password_request.dart';
import 'package:fitness_app/features/auth/data/model/requests/verify_otp_request/verify_otp_request.dart';
import 'package:fitness_app/features/auth/data/model/responses/login_response/login_response.dart';
import 'package:fitness_app/features/auth/data/repo_impl/auth_repo_impl.dart';
import 'package:fitness_app/features/auth/domain/entities/params/forget_password_param.dart';
import 'package:fitness_app/features/auth/domain/entities/params/reset_password_param.dart';
import 'package:fitness_app/features/auth/domain/entities/params/verify_otp_param.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fakes.dart';
import '../../../../helpers/test_data.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late FakeRemoteDataSource fakeRemote;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late AuthRepoImpl repo;
  late AuthRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(ForgetPasswordRequest(email: 'fallback@example.com'));
    registerFallbackValue(
      ResetPasswordRequest(email: 'fallback', newPassword: '123'),
    );
    registerFallbackValue(VerifyOtpRequest(resetCode: '0000'));
  });

  setUp(() {
    fakeRemote = FakeRemoteDataSource();
    mockRemoteDataSource = MockAuthRemoteDataSource();
    repo = AuthRepoImpl(fakeRemote, mockRemoteDataSource);
    repository = repo;
  });

  group('AuthRepoImpl', () {
    group('login', () {
      test(
        'builds LoginRequest and returns Success when remote succeeds',
        () async {
          fakeRemote.nextResponse = TestData.loginResponse;

          final result = await repo.login(
            email: TestData.validEmail,
            password: TestData.validPassword,
          );

          expect(fakeRemote.callCount, 1);
          expect(fakeRemote.lastRequest?.email, TestData.validEmail);
          expect(fakeRemote.lastRequest?.password, TestData.validPassword);
          expect(result, isA<Success<dynamic>>());
          expect((result as Success).data.token, TestData.fakeToken);
        },
      );

      test(
        'returns Error with TimeoutFailure on timeout DioException',
        () async {
          fakeRemote.nextError = DioException(
            requestOptions: RequestOptions(path: '/signin'),
            type: DioExceptionType.connectionTimeout,
          );

          final result = await repo.login(
            email: TestData.validEmail,
            password: TestData.validPassword,
          );

          expect(result, isA<Error<dynamic>>());
          expect((result as Error).failure, isA<TimeoutFailure>());
        },
      );

      test(
        'returns Error with InternetConnectionFailure on connectionError DioException',
        () async {
          fakeRemote.nextError = DioException(
            requestOptions: RequestOptions(path: '/signin'),
            type: DioExceptionType.connectionError,
          );

          final result = await repo.login(
            email: TestData.validEmail,
            password: TestData.validPassword,
          );

          expect(result, isA<Error<dynamic>>());
          expect((result as Error).failure, isA<InternetConnectionFailure>());
        },
      );

      test(
        'returns Error with UnauthorizedFailure and serverMessage on 401 badResponse',
        () async {
          fakeRemote.nextError = DioException(
            requestOptions: RequestOptions(path: '/signin'),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(path: '/signin'),
              statusCode: 401,
              data: {'message': 'Invalid credentials'},
            ),
          );

          final result = await repo.login(
            email: TestData.validEmail,
            password: TestData.validPassword,
          );

          expect(result, isA<Error<dynamic>>());
          final failure = (result as Error).failure as UnauthorizedFailure;
          expect(failure.serverMessage, 'Invalid credentials');
        },
      );

      test('returns Error with UnknownFailure on non-Dio exception', () async {
        final originalDebugPrint = debugPrint;
        debugPrint = (_, {wrapWidth}) {};

        try {
          fakeRemote.nextError = Exception('Unexpected');

          final result = await repo.login(
            email: TestData.validEmail,
            password: TestData.validPassword,
          );

          expect(result, isA<Error<dynamic>>());
          expect((result as Error).failure, isA<UnknownFailure>());
        } finally {
          debugPrint = originalDebugPrint;
        }
      });

      test(
        'returns Error when the server answers 200 without a token',
        () async {
          fakeRemote.nextResponse = LoginResponse(message: 'ok', token: '');

          final result = await repo.login(
            email: TestData.validEmail,
            password: TestData.validPassword,
          );

          expect(result, isA<Error<dynamic>>());
        },
      );
    });

    group('forgetPassword', () {
      const tParam = ForgetPasswordParam(email: 'user@example.com');

      test(
        'should return Success<void> when remoteDataSource succeeds',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.forgetPassword(any()),
          ).thenAnswer((_) async => const Success<void>(null));

          // Act
          final result = await repository.forgetPassword(tParam);

          // Assert
          expect(result, isA<Success<void>>());
          final captured = verify(
            () => mockRemoteDataSource.forgetPassword(captureAny()),
          ).captured;
          expect(
            (captured.first as ForgetPasswordRequest).email,
            equals('user@example.com'),
          );
        },
      );

      test(
        'should return Error<void> when remoteDataSource returns Error',
        () async {
          // Arrange
          const tFailure = NotFoundFailure();
          when(
            () => mockRemoteDataSource.forgetPassword(any()),
          ).thenAnswer((_) async => const Error<void>(tFailure));

          // Act
          final result = await repository.forgetPassword(tParam);

          // Assert
          expect(result, isA<Error<void>>());
          final error = result as Error<void>;
          expect(error.failure, equals(tFailure));
        },
      );
    });

    group('verifyOtp', () {
      const tParam = VerifyOtpParam('1234');

      test(
        'should return Success<void> when remoteDataSource succeeds',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.verifyOtp(any()),
          ).thenAnswer((_) async => const Success<void>(null));

          // Act
          final result = await repository.verifyOtp(tParam);

          // Assert
          expect(result, isA<Success<void>>());
          final captured = verify(
            () => mockRemoteDataSource.verifyOtp(captureAny()),
          ).captured;
          expect(
            (captured.first as VerifyOtpRequest).resetCode,
            equals('1234'),
          );
        },
      );

      test(
        'should return Error<void> when remoteDataSource returns Error',
        () async {
          // Arrange
          const tFailure = BadRequestFailure(serverMessage: 'Invalid code');
          when(
            () => mockRemoteDataSource.verifyOtp(any()),
          ).thenAnswer((_) async => const Error<void>(tFailure));

          // Act
          final result = await repository.verifyOtp(tParam);

          // Assert
          expect(result, isA<Error<void>>());
          final error = result as Error<void>;
          expect(error.failure, equals(tFailure));
        },
      );
    });

    group('resetPassword', () {
      const tParam = ResetPasswordParam(
        email: 'user@example.com',
        password: 'Password123!',
      );

      test(
        'should return Success<void> when remoteDataSource succeeds',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.resetPassword(any()),
          ).thenAnswer((_) async => const Success<void>(null));

          // Act
          final result = await repository.resetPassword(tParam);

          // Assert
          expect(result, isA<Success<void>>());
          final captured = verify(
            () => mockRemoteDataSource.resetPassword(captureAny()),
          ).captured;
          final req = captured.first as ResetPasswordRequest;
          expect(req.email, equals('user@example.com'));
          expect(req.newPassword, equals('Password123!'));
        },
      );

      test(
        'should return Error<void> when remoteDataSource returns Error',
        () async {
          // Arrange
          const tFailure = ServerFailure(statusCode: 500);
          when(
            () => mockRemoteDataSource.resetPassword(any()),
          ).thenAnswer((_) async => const Error<void>(tFailure));

          // Act
          final result = await repository.resetPassword(tParam);

          // Assert
          expect(result, isA<Error<void>>());
          final error = result as Error<void>;
          expect(error.failure, equals(tFailure));
        },
      );
    });
  });
}
