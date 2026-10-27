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
      expect(response.token, TestData.fakeToken);
      expect(response.user?.email, TestData.validEmail);
    });

    test('login throws DioException on 401 error response', () async {
      adapter.statusCode = 401;
      adapter.responseBody = {'message': 'Unauthorized'};
      adapter.exceptionToThrow = DioException(
        requestOptions: RequestOptions(path: '/auth/signin'),
        response: Response(
          requestOptions: RequestOptions(path: '/auth/signin'),
          statusCode: 401,
          data: {'message': 'Unauthorized'},
        ),
        type: DioExceptionType.badResponse,
      );

      final request = LoginRequest(
        email: TestData.validEmail,
        password: TestData.validPassword,
      );

      expect(() => client.login(request), throwsA(isA<DioException>()));
    });
  });
}
