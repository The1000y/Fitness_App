import 'package:dio/dio.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/profile/api/client/profile_api_client.dart';
import 'package:fitness_app/features/profile/api/data_source/remote/profile_remote_data_source_impl.dart';
import 'package:fitness_app/features/profile/data/model/requests/change_password_request.dart';
import 'package:fitness_app/features/profile/data/model/responses/profile_response_dto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/profile_fakes.dart';

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

  group('ProfileRemoteDataSourceImpl.getProfile', () {
    test('apiSucceeds_returnsSuccess', () async {
      final dto = ProfileResponseDto.fromJson(testProfileJson);
      when(() => apiClient.getProfile()).thenAnswer((_) async => dto);

      final result = await dataSource.getProfile();

      expect(result, isA<Success<ProfileResponseDto>>());
      expect((result as Success<ProfileResponseDto>).data.user?.id, 'user-1');
      verify(() => apiClient.getProfile()).called(1);
    });

    test('dioException_returnsErrorFailure', () async {
      when(() => apiClient.getProfile()).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/auth/profile-data'),
          type: DioExceptionType.connectionError,
        ),
      );

      final result = await dataSource.getProfile();

      expect(result, isA<Error<ProfileResponseDto>>());
    });
  });

  group('ProfileRemoteDataSourceImpl.logout', () {
    test('apiSucceeds_returnsSuccess', () async {
      when(() => apiClient.logout()).thenAnswer((_) async {});

      final result = await dataSource.logout();

      expect(result, isA<Success<void>>());
      verify(() => apiClient.logout()).called(1);
    });

    test('dioException_returnsErrorFailure', () async {
      when(() => apiClient.logout()).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/auth/logout'),
          type: DioExceptionType.connectionError,
        ),
      );

      final result = await dataSource.logout();

      expect(result, isA<Error<void>>());
    });
  });
}
