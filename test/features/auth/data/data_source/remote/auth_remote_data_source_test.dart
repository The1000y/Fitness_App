import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/features/auth/api/auth_data_source_impl.dart/remote/auth_remote_data_source_impl.dart';
import 'package:fitness_app/features/auth/data/model/requests/login_request/login_request.dart';
import '../../../../../helpers/fakes.dart';
import '../../../../../helpers/test_data.dart';

void main() {
  late FakeAuthApiClient fakeApiClient;
  late RemoteDataSourceImpl dataSource;

  setUp(() {
    fakeApiClient = FakeAuthApiClient();
    dataSource = RemoteDataSourceImpl(fakeApiClient);
  });

  group('RemoteDataSourceImpl', () {
    test('delegates login call to AuthApiClient with the correct request', () async {
      final request = LoginRequest(
        email: TestData.validEmail,
        password: TestData.validPassword,
      );
      fakeApiClient.nextResponse = TestData.loginResponse;

      final response = await dataSource.login(request);

      expect(fakeApiClient.callCount, 1);
      expect(fakeApiClient.lastRequest, request);
      expect(response.token, TestData.fakeToken);
    });
  });
}
