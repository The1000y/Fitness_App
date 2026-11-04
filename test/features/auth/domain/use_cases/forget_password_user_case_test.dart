import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/auth/domain/entities/params/forget_password_param.dart';
import 'package:fitness_app/features/auth/domain/repo/auth_repo.dart';
import 'package:fitness_app/features/auth/domain/use_cases/forget_password_user_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  late MockAuthRepo mockAuthRepo;
  late ForgetPasswordUserCase useCase;

  setUpAll(() {
    registerFallbackValue(
      const ForgetPasswordParam(email: 'fallback@example.com'),
    );
  });

  setUp(() {
    mockAuthRepo = MockAuthRepo();
    useCase = ForgetPasswordUserCase(authRepo: mockAuthRepo);
  });

  const tParam = ForgetPasswordParam(email: 'test@example.com');

  group('ForgetPasswordUserCase', () {
    test('should return Success<void> when repository call succeeds', () async {
      // Arrange
      when(
        () => mockAuthRepo.forgetPassword(any()),
      ).thenAnswer((_) async => const Success<void>(null));

      // Act
      final result = await useCase.call(tParam);

      // Assert
      expect(result, isA<Success<void>>());
      verify(() => mockAuthRepo.forgetPassword(tParam)).called(1);
      verifyNoMoreInteractions(mockAuthRepo);
    });

    test(
      'should return Error<void> with failure when repository call fails',
      () async {
        // Arrange
        const tFailure = InternetConnectionFailure();
        when(
          () => mockAuthRepo.forgetPassword(any()),
        ).thenAnswer((_) async => const Error<void>(tFailure));

        // Act
        final result = await useCase.call(tParam);

        // Assert
        expect(result, isA<Error<void>>());
        final errorResult = result as Error<void>;
        expect(errorResult.failure, equals(tFailure));
        verify(() => mockAuthRepo.forgetPassword(tParam)).called(1);
        verifyNoMoreInteractions(mockAuthRepo);
      },
    );
  });
}
