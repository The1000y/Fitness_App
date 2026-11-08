import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/core/constants/storage_keys.dart';
import 'package:fitness_app/features/profile/data/data_source/remote/profile_remote_data_source.dart';
import 'package:fitness_app/features/profile/data/model/requests/change_password_request.dart';
import 'package:fitness_app/features/profile/data/model/responses/profile_response_dto.dart';
import 'package:fitness_app/features/profile/data/repo_impl/profile_repo_impl.dart';
import 'package:fitness_app/features/profile/domain/entities/params/change_password_param.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fakes.dart';
import '../../../../helpers/profile_fakes.dart';

class MockProfileRemoteDataSource extends Mock
    implements ProfileRemoteDataSource {}

void main() {
  late MockProfileRemoteDataSource remote;
  late InMemorySecureStorage storage;
  late ProfileRepoImpl repo;

  const param = ChangePasswordParam(
    oldPassword: 'Old@1234',
    newPassword: 'New@1234',
  );

  setUpAll(() {
    registerFallbackValue(
      const ChangePasswordRequest(password: 'a', newPassword: 'b'),
    );
  });

  setUp(() {
    remote = MockProfileRemoteDataSource();
    storage = InMemorySecureStorage();
    repo = ProfileRepoImpl(remote, storage);
  });

  group('ProfileRepoImpl.changePassword', () {
    test('mapsParamToRequest_andReturnsSuccess', () async {
      when(
        () => remote.changePassword(any()),
      ).thenAnswer((_) async => const Success<void>(null));

      final result = await repo.changePassword(param);

      expect(result, isA<Success<void>>());
      final captured =
          verify(() => remote.changePassword(captureAny())).captured.single
              as ChangePasswordRequest;
      expect(captured.password, 'Old@1234');
      expect(captured.newPassword, 'New@1234');
    });

    test('remoteFails_propagatesFailure', () async {
      const failure = BadRequestFailure(serverMessage: 'Incorrect password');
      when(
        () => remote.changePassword(any()),
      ).thenAnswer((_) async => const Error<void>(failure));

      final result = await repo.changePassword(param);

      expect(
        result,
        isA<Error<void>>().having((e) => e.failure, 'failure', failure),
      );
    });
  });

  group('ProfileRepoImpl.getProfile', () {
    test('mapsDtoToEntity', () async {
      final dto = ProfileResponseDto.fromJson(testProfileJson);
      when(
        () => remote.getProfile(),
      ).thenAnswer((_) async => Success<ProfileResponseDto>(dto));

      final result = await repo.getProfile();

      expect(result, isA<Success<ProfileEntity>>());
      expect((result as Success<ProfileEntity>).data, testProfile);
      verify(() => remote.getProfile()).called(1);
    });

    test('remoteFails_propagatesFailure', () async {
      const failure = ServerFailure();
      when(
        () => remote.getProfile(),
      ).thenAnswer((_) async => const Error<ProfileResponseDto>(failure));

      final result = await repo.getProfile();

      expect(
        result,
        isA<Error<ProfileEntity>>().having(
          (e) => e.failure,
          'failure',
          failure,
        ),
      );
    });
  });

  group('ProfileRepoImpl.logout', () {
    test('clears stored session data on success', () async {
      await storage.write(key: StorageKeys.kUserToken, value: 'access-token');
      await storage.write(key: StorageKeys.kUserData, value: 'user-data');
      await storage.write(
        key: StorageKeys.kRefreshToken,
        value: 'refresh-token',
      );
      when(
        () => remote.logout(),
      ).thenAnswer((_) async => const Success<void>(null));

      final result = await repo.logout();

      expect(result, isA<Success<void>>());
      expect(await storage.read(key: StorageKeys.kUserToken), isNull);
      expect(await storage.read(key: StorageKeys.kUserData), isNull);
      expect(await storage.read(key: StorageKeys.kRefreshToken), isNull);
    });

    test('keeps session data when remote logout fails', () async {
      await storage.write(key: StorageKeys.kUserToken, value: 'access-token');
      const failure = ServerFailure();
      when(
        () => remote.logout(),
      ).thenAnswer((_) async => const Error<void>(failure));

      final result = await repo.logout();

      expect(
        result,
        isA<Error<void>>().having((e) => e.failure, 'failure', failure),
      );
      expect(await storage.read(key: StorageKeys.kUserToken), 'access-token');
    });
  });
}
