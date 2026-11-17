import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_entity.dart';
import 'package:fitness_app/features/profile/domain/repo/profile_repo.dart';
import 'package:fitness_app/features/profile/domain/use_cases/profile_get_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/profile_fakes.dart';

class MockProfileRepo extends Mock implements ProfileRepo {}

void main() {
  late MockProfileRepo repo;
  late ProfileGetUseCase useCase;

  setUp(() {
    repo = MockProfileRepo();
    useCase = ProfileGetUseCase(repo);
  });

  group('ProfileGetUseCase', () {
    test('call returns profile from repo', () async {
      when(
        () => repo.getProfile(),
      ).thenAnswer((_) async => const Success<ProfileEntity>(testProfile));

      final result = await useCase();

      expect(result, isA<Success<ProfileEntity>>());
      expect((result as Success<ProfileEntity>).data, testProfile);
      verify(() => repo.getProfile()).called(1);
    });

    test('call propagates repo failure', () async {
      const failure = ServerFailure();
      when(
        () => repo.getProfile(),
      ).thenAnswer((_) async => const Error<ProfileEntity>(failure));

      final result = await useCase();

      expect(result, isA<Error<ProfileEntity>>());
      expect((result as Error<ProfileEntity>).failure, failure);
    });
  });
}
