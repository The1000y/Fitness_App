import 'package:dio/dio.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/auth/api/auth_data_source_impl.dart/remote/auth_remote_data_source_impl.dart';
import 'package:fitness_app/features/auth/api/client/auth_api_client.dart';
import 'package:fitness_app/features/auth/data/model/requests/forget_password_request/forget_password_request.dart';
import 'package:fitness_app/features/auth/data/model/requests/reset_password_request/reset_password_request.dart';
import 'package:fitness_app/features/auth/data/model/requests/verify_otp_request/verify_otp_request.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthApiClient extends Mock implements AuthApiClient {}

void main() {
  late MockAuthApiClient mockApiClient;
  late AuthRemoteDataSourceImpl dataSource;

  setUpAll(() {
    registerFallbackValue(ForgetPasswordRequest(email: 'fallback@example.com'));
    registerFallbackValue(ResetPasswordRequest(email: 'fallback', newPassword: '123'));
    registerFallbackValue(VerifyOtpRequest(resetCode: '0000'));
  });

  setUp(() {
    mockApiClient = MockAuthApiClient();
    dataSource = AuthRemoteDataSourceImpl(authApiClient: mockApiClient);
  });

  group('AuthRemoteDataSourceImpl', () {
    group('forgetPassword', () {
      final tRequest = ForgetPasswordRequest(email: 'test@example.com');

      test('should return Success<void> when authApiClient succeeds', () async {
        // Arrange
        when(() => mockApiClient.forgetPassword(any()))
            .thenAnswer((_) async {});

        // Act
        final result = await dataSource.forgetPassword(tRequest);

        // Assert
        expect(result, isA<Success<void>>());
        verify(() => mockApiClient.forgetPassword(tRequest)).called(1);
      });

      test('should return Error<void> when authApiClient throws DioException', () async {
        // Arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/forgotPassword'),
          type: DioExceptionType.connectionError,
        );
        when(() => mockApiClient.forgetPassword(any())).thenThrow(dioException);

        // Act
        final result = await dataSource.forgetPassword(tRequest);

        // Assert
        expect(result, isA<Error<void>>());
        final error = result as Error<void>;
        expect(error.failure, isA<InternetConnectionFailure>());
        verify(() => mockApiClient.forgetPassword(tRequest)).called(1);
      });

      test('should return Error<void> with UnknownFailure on generic Exception', () async {
        // Arrange
        when(() => mockApiClient.forgetPassword(any()))
            .thenThrow(Exception('Unexpected error'));

        // Act
        final result = await dataSource.forgetPassword(tRequest);

        // Assert
        expect(result, isA<Error<void>>());
        final error = result as Error<void>;
        expect(error.failure, isA<UnknownFailure>());
      });
    });

    group('resetPassword', () {
      final tRequest = ResetPasswordRequest(
        email: 'test@example.com',
        newPassword: 'Password123!',
      );

      test('should return Success<void> when authApiClient succeeds', () async {
        // Arrange
        when(() => mockApiClient.resetPassword(any()))
            .thenAnswer((_) async {});

        // Act
        final result = await dataSource.resetPassword(tRequest);

        // Assert
        expect(result, isA<Success<void>>());
        verify(() => mockApiClient.resetPassword(tRequest)).called(1);
      });

      test('should return Error<void> when authApiClient throws DioException', () async {
        // Arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/resetPassword'),
          type: DioExceptionType.connectionTimeout,
        );
        when(() => mockApiClient.resetPassword(any())).thenThrow(dioException);

        // Act
        final result = await dataSource.resetPassword(tRequest);

        // Assert
        expect(result, isA<Error<void>>());
        final error = result as Error<void>;
        expect(error.failure, isA<TimeoutFailure>());
      });
    });

    group('verifyOtp', () {
      final tRequest = VerifyOtpRequest(resetCode: '1234');

      test('should return Success<void> when authApiClient succeeds', () async {
        // Arrange
        when(() => mockApiClient.verifyOtp(any()))
            .thenAnswer((_) async {});

        // Act
        final result = await dataSource.verifyOtp(tRequest);

        // Assert
        expect(result, isA<Success<void>>());
        verify(() => mockApiClient.verifyOtp(tRequest)).called(1);
      });

      test('should return Error<void> when authApiClient throws DioException with 400', () async {
        // Arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/verifyOtp'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/verifyOtp'),
            statusCode: 400,
            data: {'message': 'Invalid OTP'},
          ),
        );
        when(() => mockApiClient.verifyOtp(any())).thenThrow(dioException);

        // Act
        final result = await dataSource.verifyOtp(tRequest);

        // Assert
        expect(result, isA<Error<void>>());
        final error = result as Error<void>;
        expect(error.failure, isA<BadRequestFailure>());
        expect((error.failure as BadRequestFailure).serverMessage, equals('Invalid OTP'));
      });
    });
  });
}
