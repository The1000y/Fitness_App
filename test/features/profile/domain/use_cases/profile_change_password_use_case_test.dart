import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/profile/domain/entities/params/change_password_param.dart';
import 'package:fitness_app/features/profile/domain/repo/profile_repo.dart';
import 'package:fitness_app/features/profile/domain/use_cases/profile_change_password_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepo extends Mock implements ProfileRepo {}

void main() {
  late MockProfileRepo repo;
  late ProfileChangePasswordUseCase useCase;

  const param = ChangePasswordParam(
    oldPassword: 'Old@1234',
    newPassword: 'New@1234',
  );

  setUpAll(() => registerFallbackValue(param));

  setUp(() {
    repo = MockProfileRepo();
    useCase = ProfileChangePasswordUseCase(repo);
  });

  group('ProfileChangePasswordUseCase', () {
    test('call_delegatesToRepoAndReturnsSuccess', () async {
      when(
        () => repo.changePassword(any()),
      ).thenAnswer((_) async => const Success<void>(null));

      final result = await useCase(param);

      expect(result, isA<Success<void>>());
      verify(() => repo.changePassword(param)).called(1);
    });

    test('call_repoFails_returnsError', () async {
      when(
        () => repo.changePassword(any()),
      ).thenAnswer((_) async => const Error<void>(ServerFailure()));

      final result = await useCase(param);

      expect(result, isA<Error<void>>());
    });
  });
}
