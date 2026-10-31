import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/auth/domain/entities/params/verify_otp_param.dart';
import 'package:fitness_app/features/auth/domain/repo/auth_repo.dart';
import 'package:fitness_app/features/auth/domain/use_cases/verify_otp_user_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  late MockAuthRepo mockAuthRepo;
  late VerifyOtpUserCase useCase;

  setUpAll(() {
    registerFallbackValue(const VerifyOtpParam('0000'));
  });

  setUp(() {
    mockAuthRepo = MockAuthRepo();
    useCase = VerifyOtpUserCase(mockAuthRepo);
  });

  const tParam = VerifyOtpParam('1234');

  group('VerifyOtpUserCase', () {
    test('should return Success<void> when repository call succeeds', () async {
      // Arrange
      when(
        () => mockAuthRepo.verifyOtp(any()),
      ).thenAnswer((_) async => const Success<void>(null));

      // Act
      final result = await useCase.call(tParam);

      // Assert
      expect(result, isA<Success<void>>());
      verify(() => mockAuthRepo.verifyOtp(tParam)).called(1);
      verifyNoMoreInteractions(mockAuthRepo);
    });

    test(
      'should return Error<void> with failure when repository call fails',
      () async {
        // Arrange
        const tFailure = BadRequestFailure(serverMessage: 'Invalid code');
        when(
          () => mockAuthRepo.verifyOtp(any()),
        ).thenAnswer((_) async => const Error<void>(tFailure));

        // Act
        final result = await useCase.call(tParam);

        // Assert
        expect(result, isA<Error<void>>());
        final errorResult = result as Error<void>;
        expect(errorResult.failure, equals(tFailure));
        verify(() => mockAuthRepo.verifyOtp(tParam)).called(1);
        verifyNoMoreInteractions(mockAuthRepo);
      },
    );
  });
}
