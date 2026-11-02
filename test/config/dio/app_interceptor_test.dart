import 'package:dio/dio.dart';
import 'package:fitness_app/config/dio/app_interceptor.dart';
import 'package:fitness_app/core/constants/api_strings.dart';
import 'package:fitness_app/core/constants/storage_keys.dart';
import 'package:fitness_app/features/app/presentation/cubit/auth/app_auth_cubit.dart';
import 'package:fitness_app/features/app/presentation/cubit/auth/app_auth_ui_event.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../helpers/fakes.dart';

void main() {
  late InMemorySecureStorage storage;
  late AppAuthCubit authCubit;
  late Dio dio;
  late FakeHttpClientAdapter adapter;

  setUp(() {
    storage = InMemorySecureStorage();
    authCubit = AppAuthCubit();
    dio = Dio(BaseOptions(baseUrl: 'https://fitness.elevateegy.com/api/v1'));
    adapter = FakeHttpClientAdapter();
    dio.httpClientAdapter = adapter;
    dio.interceptors.add(AppInterceptors(storage, authCubit));
  });

  tearDown(() async {
    await authCubit.close();
  });

  group('AppInterceptors', () {
    test('does not attach token for public endpoints', () async {
      await storage.write(key: StorageKeys.kUserToken, value: 'my_token');
      adapter.statusCode = 200;
      adapter.responseBody = {'token': 'new_token'};

      await dio.post(ApiStrings.signin);

      expect(adapter.lastRequestOptions?.headers['Authorization'], isNull);
    });

    test('attaches Bearer token for protected endpoints when token exists', () async {
      await storage.write(key: StorageKeys.kUserToken, value: 'valid_jwt_token');
      adapter.statusCode = 200;
      adapter.responseBody = {'message': 'success'};

      await dio.get('/user/profile');

      expect(adapter.lastRequestOptions?.headers['Authorization'], 'Bearer valid_jwt_token');
    });

    test('does not attach Authorization header if no token in storage', () async {
      adapter.statusCode = 200;
      adapter.responseBody = {'message': 'success'};

      await dio.get('/user/profile');

      expect(adapter.lastRequestOptions?.headers['Authorization'], isNull);
    });

    test('onResponse on signIn saves returned token to storage', () async {
      adapter.statusCode = 200;
      adapter.responseBody = {'token': 'new_login_token'};

      await dio.post(ApiStrings.signin);

      final savedToken = await storage.read(key: StorageKeys.kUserToken);
      expect(savedToken, 'new_login_token');
    });

    test('onError on protected 401 clears token and triggers sessionExpired on authCubit', () async {
      await storage.write(key: StorageKeys.kUserToken, value: 'expired_token');
      adapter.statusCode = 401;
      adapter.responseBody = {'message': 'Unauthorized'};

      final events = <AppAuthUiEvent>[];
      final subscription = authCubit.uiEventStream.listen(events.add);

      await expectLater(
        dio.get('/user/profile'),
        throwsA(isA<DioException>()),
      );
      await pumpEventQueue();

      final savedToken = await storage.read(key: StorageKeys.kUserToken);
      expect(savedToken, isNull);

      expect(events.length, 1);
      expect(events.first, isA<SessionExpiredUiEvent>());

      await subscription.cancel();
    });

    test('onError on public 401 does not clear token or trigger sessionExpired', () async {
      await storage.write(key: StorageKeys.kUserToken, value: 'some_token');
      adapter.statusCode = 401;
      adapter.responseBody = {'message': 'Invalid credentials'};

      final events = <AppAuthUiEvent>[];
      final subscription = authCubit.uiEventStream.listen(events.add);

      await expectLater(
        dio.post(ApiStrings.signin),
        throwsA(isA<DioException>()),
      );
      await pumpEventQueue();

      final savedToken = await storage.read(key: StorageKeys.kUserToken);
      expect(savedToken, 'some_token');
      expect(events, isEmpty);

      await subscription.cancel();
    });
  });
}
