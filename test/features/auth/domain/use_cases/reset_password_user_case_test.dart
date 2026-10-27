import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/auth/domain/entities/params/reset_password_param.dart';
import 'package:fitness_app/features/auth/domain/repo/auth_repo.dart';
import 'package:fitness_app/features/auth/domain/use_cases/reset_password_user_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  late MockAuthRepo mockAuthRepo;
  late ResetPasswordUserCase useCase;

  setUpAll(() {
    registerFallbackValue(
      const ResetPasswordParam(
        email: 'fallback@example.com',
        password: 'Password1!',
      ),
    );
  });

  setUp(() {
    mockAuthRepo = MockAuthRepo();
    useCase = ResetPasswordUserCase(mockAuthRepo);
  });

  const tParam = ResetPasswordParam(
    email: 'user@example.com',
    password: 'NewPassword123!',
  );

  group('ResetPasswordUserCase', () {
    test('should return Success<void> when repository call succeeds', () async {
      // Arrange
      when(() => mockAuthRepo.resetPassword(any()))
          .thenAnswer((_) async => const Success<void>(null));

      // Act
      final result = await useCase.call(tParam);

      // Assert
      expect(result, isA<Success<void>>());
      verify(() => mockAuthRepo.resetPassword(tParam)).called(1);
      verifyNoMoreInteractions(mockAuthRepo);
    });

    test('should return Error<void> with failure when repository call fails', () async {
      // Arrange
      const tFailure = ServerFailure(statusCode: 500);
      when(() => mockAuthRepo.resetPassword(any()))
          .thenAnswer((_) async => const Error<void>(tFailure));

      // Act
      final result = await useCase.call(tParam);

      // Assert
      expect(result, isA<Error<void>>());
      final errorResult = result as Error<void>;
      expect(errorResult.failure, equals(tFailure));
      verify(() => mockAuthRepo.resetPassword(tParam)).called(1);
      verifyNoMoreInteractions(mockAuthRepo);
    });
  });
}
