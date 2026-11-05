import 'package:dio/dio.dart';
import 'package:fitness_app/features/profile/api/client/profile_api_client.dart';
import 'package:fitness_app/features/profile/data/model/requests/change_password_request.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fakes.dart';

void main() {
  late FakeHttpClientAdapter adapter;
  late ProfileApiClient client;

  const request = ChangePasswordRequest(
    password: 'Old@1234',
    newPassword: 'New@1234',
  );

  setUp(() {
    final dio = Dio(
      BaseOptions(baseUrl: 'https://fitness.elevateegy.com/api/v1'),
    );
    adapter = FakeHttpClientAdapter();
    dio.httpClientAdapter = adapter;
    client = ProfileApiClient(dio);
  });

  group('ProfileApiClient.changePassword', () {
    test('sendsPatchToChangePasswordPathWithBody', () async {
      adapter.statusCode = 200;
      adapter.responseBody = {'message': 'success'};

      await client.changePassword(request);

      expect(adapter.lastRequestOptions?.method, 'PATCH');
      expect(
        adapter.lastRequestOptions?.path,
        contains('/auth/change-password'),
      );
      expect(adapter.lastRequestOptions?.data, {
        'password': 'Old@1234',
        'newPassword': 'New@1234',
      });
    });

    test('badResponse_throwsDioException', () async {
      adapter.statusCode = 400;
      adapter.responseBody = {'error': 'Incorrect password'};

      await expectLater(
        client.changePassword(request),
        throwsA(
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'statusCode',
            400,
          ),
        ),
      );
    });
  });
}
