import 'package:dio/dio.dart';
import 'package:fitness_app/features/profile/api/client/profile_api_client.dart';
import 'package:fitness_app/features/profile/data/model/requests/change_password_request.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fakes.dart';
import '../../../../helpers/profile_fakes.dart';

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

  group('ProfileApiClient.getProfile', () {
    test('sendsGetToProfilePathAndParsesResponse', () async {
      adapter.statusCode = 200;
      adapter.responseBody = testProfileJson;

      final response = await client.getProfile();

      expect(adapter.lastRequestOptions?.method, 'GET');
      expect(adapter.lastRequestOptions?.path, contains('/auth/profile-data'));
      expect(response.message, 'Profile fetched successfully');
      expect(response.user?.id, 'user-1');
      expect(response.user?.firstName, 'Ada');
    });

    test('badResponse_throwsDioException', () async {
      adapter.statusCode = 401;
      adapter.responseBody = {'message': 'Unauthorized'};

      await expectLater(
        client.getProfile(),
        throwsA(
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'statusCode',
            401,
          ),
        ),
      );
    });
  });

  group('ProfileApiClient.logout', () {
    test('sendsGetToLogoutPath', () async {
      adapter.statusCode = 200;
      adapter.responseBody = {'message': 'Logged out'};

      await client.logout();

      expect(adapter.lastRequestOptions?.method, 'GET');
      expect(adapter.lastRequestOptions?.path, contains('/auth/logout'));
    });

    test('badResponse_throwsDioException', () async {
      adapter.statusCode = 500;
      adapter.responseBody = {'message': 'Server error'};

      await expectLater(
        client.logout(),
        throwsA(
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'statusCode',
            500,
          ),
        ),
      );
    });
  });
}
