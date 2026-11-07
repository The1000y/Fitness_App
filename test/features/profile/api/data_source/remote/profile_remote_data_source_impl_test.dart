import 'package:dio/dio.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/profile/api/client/profile_api_client.dart';
import 'package:fitness_app/features/profile/api/data_source/remote/profile_remote_data_source_impl.dart';
import 'package:fitness_app/features/profile/data/model/requests/change_password_request.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileApiClient extends Mock implements ProfileApiClient {}

void main() {
  late MockProfileApiClient apiClient;
  late ProfileRemoteDataSourceImpl dataSource;

  const request = ChangePasswordRequest(
    password: 'Old@1234',
    newPassword: 'New@1234',
  );

  setUpAll(() => registerFallbackValue(request));

  setUp(() {
    apiClient = MockProfileApiClient();
    dataSource = ProfileRemoteDataSourceImpl(apiClient);
  });

  group('ProfileRemoteDataSourceImpl.changePassword', () {
    test('apiSucceeds_returnsSuccess', () async {
      when(() => apiClient.changePassword(any())).thenAnswer((_) async {});

      final result = await dataSource.changePassword(request);

      expect(result, isA<Success<void>>());
      verify(() => apiClient.changePassword(request)).called(1);
    });

    test('dioException_returnsErrorFailure', () async {
      when(() => apiClient.changePassword(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/auth/change-password'),
          type: DioExceptionType.connectionError,
        ),
      );

      final result = await dataSource.changePassword(request);

      expect(result, isA<Error<void>>());
    });

    test('unexpectedException_returnsUnknownFailure', () async {
      when(() => apiClient.changePassword(any())).thenThrow(StateError('boom'));

      final result = await dataSource.changePassword(request);

      expect(
        result,
        isA<Error<void>>().having(
          (e) => e.failure,
          'failure',
          isA<UnknownFailure>(),
        ),
      );
    });
  });
}
