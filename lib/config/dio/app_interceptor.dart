import 'package:dio/dio.dart';
import 'package:fitness_app/core/constants/api_strings.dart';
import 'package:fitness_app/core/constants/storage_keys.dart';
import 'package:fitness_app/features/app/presentation/cubit/auth/app_auth_cubit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AppInterceptors extends QueuedInterceptor {
  AppInterceptors(this._storage, this._authCubit);

  final FlutterSecureStorage _storage;
  final AppAuthCubit _authCubit;
  static final String _signInPath = ApiStrings.signin;
  static final String _signUpPath = ApiStrings.signup;
  static final String _forgotPasswordPath = ApiStrings.forgotPassword;
  static final String _verifyResetCodePath = ApiStrings.verifyResetCode;
  static final String _resetPasswordPath = ApiStrings.resetPassword;

  static final List<String> _publicPaths = [
    _signInPath,
    _signUpPath,
    _forgotPasswordPath,
    _verifyResetCodePath,
    _resetPasswordPath,
  ];

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
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
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
      _authCubit.sessionExpired();
    }
    handler.next(err);
  }

  bool _isPublic(RequestOptions o) =>
      _publicPaths.any((p) => o.path.contains(p));

  Future<void> setToken(String token) =>
      _storage.write(key: StorageKeys.kUserToken, value: token);

  Future<void> clearToken() => _storage.delete(key: StorageKeys.kUserToken);

  Future<bool> get hasToken async {
    final token = await _storage.read(key: StorageKeys.kUserToken);
    return token != null && token.isNotEmpty;
  }
}
