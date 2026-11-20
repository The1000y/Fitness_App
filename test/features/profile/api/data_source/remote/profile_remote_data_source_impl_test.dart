import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/profile/api/client/profile_api_client.dart';
import 'package:fitness_app/features/profile/api/data_source/remote/profile_remote_data_source_impl.dart';
import 'package:fitness_app/features/profile/data/model/requests/change_password_request.dart';
import 'package:fitness_app/features/profile/data/model/requests/profile_update_request.dart';
import 'package:fitness_app/features/profile/data/model/responses/profile_response_dto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/profile_fakes.dart';

class MockProfileApiClient extends Mock implements ProfileApiClient {}

void main() {
  late MockProfileApiClient apiClient;
  late ProfileRemoteDataSourceImpl dataSource;
  Directory? tempDir;

  const request = ChangePasswordRequest(
    password: 'Old@1234',
    newPassword: 'New@1234',
  );

  const updateRequest = ProfileUpdateRequest(
    firstName: 'Ada',
    lastName: 'Lovelace',
  );

  setUpAll(() {
    registerFallbackValue(request);
    registerFallbackValue(updateRequest);
    registerFallbackValue(MultipartFile.fromBytes([]));
  });

  setUp(() {
    apiClient = MockProfileApiClient();
    dataSource = ProfileRemoteDataSourceImpl(apiClient);
  });

  tearDown(() {
    if (tempDir != null && tempDir!.existsSync()) {
      tempDir!.deleteSync(recursive: true);
    }
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

  group('ProfileRemoteDataSourceImpl.updateProfile', () {
    test('updateProfile_success_returnsSuccessAndCallsApiClient', () async {
      final dto = ProfileResponseDto.fromJson(testProfileJson);
      when(() => apiClient.updateProfile(any())).thenAnswer((_) async => dto);

      final result = await dataSource.updateProfile(updateRequest);

      expect(result, isA<Success<ProfileResponseDto>>());
      expect((result as Success<ProfileResponseDto>).data.user?.id, 'user-1');
      verify(() => apiClient.updateProfile(updateRequest)).called(1);
    });

    test('updateProfile_dioException_returnsErrorFailure', () async {
      when(() => apiClient.updateProfile(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/auth/editProfile'),
          type: DioExceptionType.connectionError,
        ),
      );

      final result = await dataSource.updateProfile(updateRequest);

      expect(result, isA<Error<ProfileResponseDto>>());
    });

    test('updateProfile_genericException_returnsErrorWithUnknownFailure', () async {
      when(() => apiClient.updateProfile(any())).thenThrow(Exception('boom'));

      final result = await dataSource.updateProfile(updateRequest);

      expect(
        result,
        isA<Error<ProfileResponseDto>>().having(
          (e) => e.failure,
          'failure',
          isA<UnknownFailure>(),
        ),
      );
    });
  });

  group('ProfileRemoteDataSourceImpl.uploadPhoto', () {
    test('uploadPhoto_tempFileSuccess_returnsSuccessAndPassesFilenameOnly', () async {
      tempDir = Directory.systemTemp.createTempSync('upload_photo_test_');
      final tempFile = File('${tempDir!.path}/avatar.png')
        ..writeAsBytesSync([1, 2, 3]);

      when(() => apiClient.uploadPhoto(any())).thenAnswer((_) async {});

      final result = await dataSource.uploadPhoto(tempFile.path);

      expect(result, isA<Success<void>>());

      final captured = verify(() => apiClient.uploadPhoto(captureAny())).captured.single as MultipartFile;
      expect(captured.filename, 'avatar.png');
    });

    test('uploadPhoto_fileNotFound_returnsUnknownFailureWithoutCallingApiClient', () async {
      const nonExistentPath = '/path/does/not/exist/image_404.png';

      final result = await dataSource.uploadPhoto(nonExistentPath);

      expect(
        result,
        isA<Error<void>>().having(
          (e) => e.failure,
          'failure',
          isA<UnknownFailure>(),
        ),
      );
      verifyZeroInteractions(apiClient);
    });

    test('uploadPhoto_dioException_returnsErrorFailure', () async {
      tempDir = Directory.systemTemp.createTempSync('upload_photo_err_');
      final tempFile = File('${tempDir!.path}/avatar.png')
        ..writeAsBytesSync([1, 2, 3]);

      when(() => apiClient.uploadPhoto(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/auth/upload-photo'),
          type: DioExceptionType.badResponse,
        ),
      );

      final result = await dataSource.uploadPhoto(tempFile.path);

      expect(result, isA<Error<void>>());
    });
  });
}
