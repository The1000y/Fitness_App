import 'package:dio/dio.dart';
import 'package:fitness_app/config/dio/app_interceptor.dart';
import 'package:fitness_app/core/constants/api_strings.dart';
import 'package:fitness_app/core/constants/storage_keys.dart';
import 'package:fitness_app/features/app/presentation/cubit/auth/app_auth_cubit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class MockAppAuthCubit extends Mock implements AppAuthCubit {}

class MockRequestInterceptorHandler extends Mock
    implements RequestInterceptorHandler {}

class MockResponseInterceptorHandler extends Mock
    implements ResponseInterceptorHandler {}

class MockErrorInterceptorHandler extends Mock
    implements ErrorInterceptorHandler {}

void main() {
  late MockFlutterSecureStorage mockStorage;
  late MockAppAuthCubit mockAuthCubit;
  late AppInterceptors interceptor;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    mockAuthCubit = MockAppAuthCubit();
    interceptor = AppInterceptors(mockStorage, mockAuthCubit);
  });

  group('AppInterceptors', () {
    group('onRequest', () {
      test(
        'adds Bearer token when route is private and token exists',
        () async {
          final options = RequestOptions(path: '/user/profile');
          final handler = MockRequestInterceptorHandler();
          when(
            () => mockStorage.read(key: StorageKeys.kUserToken),
          ).thenAnswer((_) async => 'valid_token_123');

          await interceptor.onRequest(options, handler);

          expect(
            options.headers['Authorization'],
            equals('Bearer valid_token_123'),
          );
          verify(() => handler.next(options)).called(1);
        },
      );

      test('does not add token when route is public', () async {
        final options = RequestOptions(path: ApiStrings.signin);
        final handler = MockRequestInterceptorHandler();

        await interceptor.onRequest(options, handler);

        expect(options.headers.containsKey('Authorization'), isFalse);
        verifyZeroInteractions(mockStorage);
        verify(() => handler.next(options)).called(1);
      });

      test('does not add token when stored token is null or empty', () async {
        final options = RequestOptions(path: '/user/profile');
        final handler = MockRequestInterceptorHandler();
        when(
          () => mockStorage.read(key: StorageKeys.kUserToken),
        ).thenAnswer((_) async => null);

        await interceptor.onRequest(options, handler);

        expect(options.headers.containsKey('Authorization'), isFalse);
        verify(() => handler.next(options)).called(1);
      });
    });

    group('onResponse', () {
      test('stores token when response is from signin path', () async {
        final options = RequestOptions(path: ApiStrings.signin);
        final response = Response(
          requestOptions: options,
          data: {'token': 'jwt_secret_token'},
        );
        final handler = MockResponseInterceptorHandler();
        when(
          () => mockStorage.write(
            key: StorageKeys.kUserToken,
            value: 'jwt_secret_token',
          ),
        ).thenAnswer((_) async {});

        await interceptor.onResponse(response, handler);

        verify(
          () => mockStorage.write(
            key: StorageKeys.kUserToken,
            value: 'jwt_secret_token',
          ),
        ).called(1);
        verify(() => handler.next(response)).called(1);
      });

      test('does not store token when path is not signin', () async {
        final options = RequestOptions(path: '/user/profile');
        final response = Response(
          requestOptions: options,
          data: {'token': 'token'},
        );
        final handler = MockResponseInterceptorHandler();

        await interceptor.onResponse(response, handler);

        verifyNever(
          () => mockStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        );
        verify(() => handler.next(response)).called(1);
      });
    });

    group('onError', () {
      test(
        'clears token and calls sessionExpired on 401 for private path',
        () async {
          final options = RequestOptions(path: '/user/settings');
          final error = DioException(
            requestOptions: options,
            response: Response(requestOptions: options, statusCode: 401),
          );
          final handler = MockErrorInterceptorHandler();
          when(
            () => mockStorage.delete(key: StorageKeys.kUserToken),
          ).thenAnswer((_) async {});

          await interceptor.onError(error, handler);

          verify(
            () => mockStorage.delete(key: StorageKeys.kUserToken),
          ).called(1);
          verify(() => mockAuthCubit.sessionExpired()).called(1);
          verify(() => handler.next(error)).called(1);
        },
      );

      test(
        'does not clear token or expire session on 401 for public path',
        () async {
          final options = RequestOptions(path: ApiStrings.signin);
          final error = DioException(
            requestOptions: options,
            response: Response(requestOptions: options, statusCode: 401),
          );
          final handler = MockErrorInterceptorHandler();

          await interceptor.onError(error, handler);

          verifyNever(() => mockStorage.delete(key: any(named: 'key')));
          verifyNever(() => mockAuthCubit.sessionExpired());
          verify(() => handler.next(error)).called(1);
        },
      );

      test('does not clear token on non-401 status code', () async {
        final options = RequestOptions(path: '/user/settings');
        final error = DioException(
          requestOptions: options,
          response: Response(requestOptions: options, statusCode: 500),
        );
        final handler = MockErrorInterceptorHandler();

        await interceptor.onError(error, handler);

        verifyNever(() => mockStorage.delete(key: any(named: 'key')));
        verifyNever(() => mockAuthCubit.sessionExpired());
        verify(() => handler.next(error)).called(1);
      });
    });

    group('token helper methods', () {
      test('setToken writes to storage', () async {
        when(
          () =>
              mockStorage.write(key: StorageKeys.kUserToken, value: 'my_token'),
        ).thenAnswer((_) async {});

        await interceptor.setToken('my_token');

        verify(
          () =>
              mockStorage.write(key: StorageKeys.kUserToken, value: 'my_token'),
        ).called(1);
      });

      test('clearToken deletes from storage', () async {
        when(
          () => mockStorage.delete(key: StorageKeys.kUserToken),
        ).thenAnswer((_) async {});

        await interceptor.clearToken();

        verify(() => mockStorage.delete(key: StorageKeys.kUserToken)).called(1);
      });

      test('hasToken returns true when token exists', () async {
        when(
          () => mockStorage.read(key: StorageKeys.kUserToken),
        ).thenAnswer((_) async => 'existing_token');

        final result = await interceptor.hasToken;

        expect(result, isTrue);
      });

      test('hasToken returns false when token is null or empty', () async {
        when(
          () => mockStorage.read(key: StorageKeys.kUserToken),
        ).thenAnswer((_) async => null);

        final resultNull = await interceptor.hasToken;
        expect(resultNull, isFalse);

        when(
          () => mockStorage.read(key: StorageKeys.kUserToken),
        ).thenAnswer((_) async => '');

        final resultEmpty = await interceptor.hasToken;
        expect(resultEmpty, isFalse);
      });
    });
  });
}
