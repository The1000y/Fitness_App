import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/profile/domain/entities/params/update_profile_param.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_entity.dart';
import 'package:fitness_app/features/profile/domain/repo/profile_repo.dart';
import 'package:fitness_app/features/profile/domain/use_cases/profile_update_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/profile_fakes.dart';

class MockProfileRepo extends Mock implements ProfileRepo {}

void main() {
  late MockProfileRepo repo;
  late ProfileUpdateUseCase useCase;

  const param = UpdateProfileParam(
    firstName: 'Jane',
    lastName: 'Doe',
  );

  setUp(() {
    repo = MockProfileRepo();
    useCase = ProfileUpdateUseCase(repo);
  });

  group('ProfileUpdateUseCase', () {
    test('call_delegatesToRepoAndReturnsSuccess', () async {
      when(() => repo.updateProfile(param)).thenAnswer(
        (_) async => const Success<ProfileEntity>(testProfile),
      );

      final result = await useCase(param);

      expect(result, isA<Success<ProfileEntity>>());
      expect((result as Success<ProfileEntity>).data, testProfile);
      verify(() => repo.updateProfile(param)).called(1);
    });

    test('call_repoFails_returnsError', () async {
      const failure = ServerFailure();
      when(() => repo.updateProfile(param)).thenAnswer(
        (_) async => const Error<ProfileEntity>(failure),
      );

      final result = await useCase(param);

      expect(result, isA<Error<ProfileEntity>>());
      expect((result as Error<ProfileEntity>).failure, failure);
      verify(() => repo.updateProfile(param)).called(1);
    });
  });
}
