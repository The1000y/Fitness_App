import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/features/auth/api/client/auth_api_client.dart';
import 'package:fitness_app/features/auth/data/model/requests/login_request/login_request.dart';
import '../../../../helpers/fakes.dart';
import '../../../../helpers/test_data.dart';

void main() {
  late Dio dio;
  late FakeHttpClientAdapter adapter;
  late AuthApiClient client;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://fitness.elevateegy.com/api/v1'));
    adapter = FakeHttpClientAdapter();
    dio.httpClientAdapter = adapter;
    client = AuthApiClient(dio);
  });

  group('AuthApiClient', () {
    test('login sends request to signin path with credentials and parses response', () async {
      adapter.statusCode = 200;
      adapter.responseBody = TestData.loginResponseJson;

      final request = LoginRequest(
        email: TestData.validEmail,
        password: TestData.validPassword,
      );

      final response = await client.login(request);

      expect(adapter.lastRequestOptions?.path, contains('/auth/signin'));
      expect(adapter.lastRequestOptions?.method, 'POST');
      expect(adapter.lastRequestOptions?.data, {'email': TestData.validEmail, 'password': TestData.validPassword});
      expect(response.token, TestData.fakeToken);
      expect(response.user?.email, TestData.validEmail);
    });

    test('login throws DioException on 401 error response', () async {
      adapter.statusCode = 401;
      adapter.responseBody = {'message': 'Unauthorized'};

      final request = LoginRequest(
        email: TestData.validEmail,
        password: TestData.validPassword,
      );

      await expectLater(
        client.login(request),
        throwsA(
          isA<DioException>()
              .having((e) => e.response?.statusCode, 'statusCode', 401)
              .having((e) => e.type, 'type', DioExceptionType.badResponse),
        ),
      );
    });
  });
}
