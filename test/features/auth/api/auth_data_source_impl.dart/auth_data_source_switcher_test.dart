import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/auth/api/auth_data_source_impl.dart/auth_data_source_switcher.dart';
import 'package:fitness_app/features/auth/api/auth_data_source_impl.dart/remote/auth_fake_remote_data_source_impl.dart';
import 'package:fitness_app/features/auth/api/auth_data_source_impl.dart/remote/auth_remote_data_source_impl.dart';
import 'package:fitness_app/features/auth/data/model/requests/forget_password_request/forget_password_request.dart';
import 'package:fitness_app/features/auth/data/model/requests/reset_password_request/reset_password_request.dart';
import 'package:fitness_app/features/auth/data/model/requests/verify_otp_request/verify_otp_request.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSourceImpl extends Mock
    implements AuthRemoteDataSourceImpl {}

class MockAuthLocalDataSourceImpl extends Mock
    implements AuthFakeRemoteDataSourceImpl {}

void main() {
  late MockAuthRemoteDataSourceImpl mockRemote;
  late MockAuthLocalDataSourceImpl mockLocal;
  late AuthDataSourceSwitcher switcher;

  setUpAll(() {
    registerFallbackValue(ForgetPasswordRequest(email: 'fallback@example.com'));
    registerFallbackValue(ResetPasswordRequest(email: 'fallback', newPassword: '123'));
    registerFallbackValue(VerifyOtpRequest(resetCode: '0000'));
  });

  setUp(() {
    mockRemote = MockAuthRemoteDataSourceImpl();
    mockLocal = MockAuthLocalDataSourceImpl();
    switcher = AuthDataSourceSwitcher(
      authRemoteDataSourceImpl: mockRemote,
      authLocalDataSourceImpl: mockLocal,
    );
  });

  group('AuthDataSourceSwitcher', () {
    test('forgetPassword delegates to local data source when useDummyData is true', () async {
      final tRequest = ForgetPasswordRequest(email: 'test@example.com');
      when(() => mockLocal.forgetPassword(any()))
          .thenAnswer((_) async => const Success<void>(null));

      final result = await switcher.forgetPassword(tRequest);

      expect(result, isA<Success<void>>());
      verify(() => mockLocal.forgetPassword(tRequest)).called(1);
      verifyZeroInteractions(mockRemote);
    });

    test('resetPassword delegates to local data source when useDummyData is true', () async {
      final tRequest = ResetPasswordRequest(
        email: 'test@example.com',
        newPassword: 'Password1!',
      );
      when(() => mockLocal.resetPassword(any()))
          .thenAnswer((_) async => const Success<void>(null));

      final result = await switcher.resetPassword(tRequest);

      expect(result, isA<Success<void>>());
      verify(() => mockLocal.resetPassword(tRequest)).called(1);
      verifyZeroInteractions(mockRemote);
    });

    test('verifyOtp delegates to local data source when useDummyData is true', () async {
      final tRequest = VerifyOtpRequest(resetCode: '1234');
      when(() => mockLocal.verifyOtp(any()))
          .thenAnswer((_) async => const Success<void>(null));

      final result = await switcher.verifyOtp(tRequest);

      expect(result, isA<Success<void>>());
      verify(() => mockLocal.verifyOtp(tRequest)).called(1);
      verifyZeroInteractions(mockRemote);
    });
  });
}
