import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/profile/domain/repo/profile_repo.dart';
import 'package:fitness_app/features/profile/domain/use_cases/profile_logout_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepo extends Mock implements ProfileRepo {}

void main() {
  late MockProfileRepo repo;
  late ProfileLogoutUseCase useCase;

  setUp(() {
    repo = MockProfileRepo();
    useCase = ProfileLogoutUseCase(repo);
  });

  group('ProfileLogoutUseCase', () {
    test('call returns success from repo', () async {
      when(
        () => repo.logout(),
      ).thenAnswer((_) async => const Success<void>(null));

      final result = await useCase();

      expect(result, isA<Success<void>>());
      verify(() => repo.logout()).called(1);
    });

    test('call propagates repo failure', () async {
      const failure = ServerFailure();
      when(
        () => repo.logout(),
      ).thenAnswer((_) async => const Error<void>(failure));

      final result = await useCase();

      expect(result, isA<Error<void>>());
      expect((result as Error<void>).failure, failure);
    });
  });
}
