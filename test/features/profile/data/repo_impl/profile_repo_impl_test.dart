import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/profile/data/data_source/remote/profile_remote_data_source.dart';
import 'package:fitness_app/features/profile/data/model/requests/change_password_request.dart';
import 'package:fitness_app/features/profile/data/repo_impl/profile_repo_impl.dart';
import 'package:fitness_app/features/profile/domain/entities/params/change_password_param.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRemoteDataSource extends Mock
    implements ProfileRemoteDataSource {}

void main() {
  late MockProfileRemoteDataSource remote;
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
    repo = ProfileRepoImpl(remote);
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
}
