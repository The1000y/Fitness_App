import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AppInterceptors extends QueuedInterceptor {
  AppInterceptors(this._storage);

  final FlutterSecureStorage _storage;
  static const String _signInPath = '/auth/signin';
  static const String _signUpPath = '/auth/signup';

  static const List<String> _publicPaths = [_signInPath, _signUpPath];

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_isPublic(options)) {
      final token = await _storage.read(key: StorageKeys.kUserToken);
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.requestOptions.path.contains(_signInPath)) {
      await setToken(response.data["token"]);
    }

    handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // التوكين خلص أو مش صالح -> امسحه
    if (err.response?.statusCode == 401 && !_isPublic(err.requestOptions)) {
      await clearToken();
    }
    handler.next(err);
  }

  bool _isPublic(RequestOptions o) => _publicPaths.any((p) => o.path.contains(p));

  Future<void> setToken(String token) => _storage.write(key: StorageKeys.kUserToken, value: token);

  Future<void> clearToken() => _storage.delete(key: StorageKeys.kUserToken);

  Future<bool> get hasToken async {
    final token = await _storage.read(key: StorageKeys.kUserToken);
    return token != null && token.isNotEmpty;
  }
}

abstract final class StorageKeys {
  static const String kUserToken = 'access_token';
  static const String kUserData = 'user_data';
  static const String kRefreshToken = 'refresh_token';
}
