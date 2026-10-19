/*
1) لو الـ API مش بيرجع refresh token، هيأثر؟

مش هيبوّظ حاجة. اللي هيحصل لما يجي 401:

الكود يدوّر على الـ refresh token في الـ storage ومش هيلاقيه.
يمسح التوكين ويرجّع الـ error عادي.

يعني عملياً هيشتغل كأنه "لو التوكين خلص امسحه". بس كل كود الـ refresh و_plainDio ده هيبقى ملوش لازمة، فالأحسن تشيله وتستخدم النسخة الأبسط تحت.

2) اللي لازم تغيّره عشان يتماشى مع مشروعك

لو الـ API ليه refresh token:

_refreshPath: حط رابط الـ refresh الحقيقي من الـ Postman.
_publicPaths: حط روابط الـ login/register الحقيقية بتاعتك (مش اللي أنا كاتبها، دي أمثلة).
في _refreshToken(): شكل الـ body ({'refreshToken': ...}) وأسماء الحقول في الرد (token, refreshToken) لازم تطابق الـ API.
بعد الـ login استدعي setTokens(token, refreshToken).
ضيف import الـ ApiStrings، وسيب StorageKeys في مكان واحد بس.


*/




import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

// Add to StorageKeys:
// static const String kRefreshToken = 'refresh_token';

/// QueuedInterceptor = Interceptor عادي، بس بيرتب الـ requests اللي فشلت
/// واحد ورا التاني، فمش هيحصل أكتر من refresh في نفس الوقت.
@lazySingleton
class AppInterceptors extends QueuedInterceptor {
  AppInterceptors(this._storage);

  final FlutterSecureStorage _storage;

  // ---------------------------------------------------------------------------
  // Settings (غيّرهم حسب المشروع)
  // ---------------------------------------------------------------------------
  static const String _refreshPath = '/api/auth/refresh-token';

  // endpoints مش محتاجة توكين
  static const List<String> _publicPaths = [
    '/api/auth/signin',
    '/api/auth/signup',
    _refreshPath,
  ];

  // Dio منفصل من غير interceptors، للـ refresh وللإعادة (عشان ما نعملش loop)
  final Dio _plainDio = Dio(BaseOptions(baseUrl: ApiStrings.baseUrl));

  // ---------------------------------------------------------------------------
  // 1) Request: حط التوكين
  // ---------------------------------------------------------------------------
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

  // ---------------------------------------------------------------------------
  // 2) Error: لو 401 جدد التوكين وأعد الـ request
  // ---------------------------------------------------------------------------
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;

    final shouldRefresh = err.response?.statusCode == 401 &&
        !_isPublic(options) &&
        options.extra['retried'] != true;

    if (!shouldRefresh) return handler.next(err);

    // لو حد تاني جدد التوكين وإحنا في الطابور، أعد بالتوكين الجديد بس
    final sent = options.headers['Authorization'];
    final current = await _storage.read(key: StorageKeys.kUserToken);
    if (current != null && current.isNotEmpty && sent != 'Bearer $current') {
      return _retry(options, current, handler);
    }

    final newToken = await _refreshToken();
    if (newToken == null) return handler.next(err);

    return _retry(options, newToken, handler);
  }

  // ---------------------------------------------------------------------------
  // Refresh
  // ---------------------------------------------------------------------------
  Future<String?> _refreshToken() async {
    final refreshToken = await _storage.read(key: StorageKeys.kRefreshToken);
    if (refreshToken == null || refreshToken.isEmpty) {
      await clearTokens();
      return null;
    }

    try {
      final response = await _plainDio.post(
        _refreshPath,
        data: {'refreshToken': refreshToken}, // عدّلها حسب الـ backend
      );

      // عدّل أسماء الحقول حسب رد الـ backend
      final data = response.data;
      final newAccess = data['token'] as String?;
      final newRefresh = data['refreshToken'] as String?;

      if (newAccess == null) return null;
      await setTokens(newAccess, newRefresh ?? refreshToken);
      return newAccess;
    } on DioException catch (e) {
      // لو السيرفر رفض الـ refresh token يبقى الجلسة خلصت
      final code = e.response?.statusCode;
      if (code == 400 || code == 401 || code == 403) await clearTokens();
      return null;
    }
  }

  Future<void> _retry(
    RequestOptions options,
    String token,
    ErrorInterceptorHandler handler,
  ) async {
    options.headers['Authorization'] = 'Bearer $token';
    options.extra['retried'] = true;
    try {
      handler.resolve(await _plainDio.fetch(options));
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  bool _isPublic(RequestOptions options) =>
      _publicPaths.any((p) => options.path.contains(p));

  // ---------------------------------------------------------------------------
  // Token API (استخدمها بعد login / logout)
  // ---------------------------------------------------------------------------
  Future<void> setTokens(String access, [String? refresh]) async {
    await _storage.write(key: StorageKeys.kUserToken, value: access);
    if (refresh != null) {
      await _storage.write(key: StorageKeys.kRefreshToken, value: refresh);
    }
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: StorageKeys.kUserToken);
    await _storage.delete(key: StorageKeys.kRefreshToken);
  }

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

/*
لو الـ API مفيهوش refresh token (حالتك على الأغلب): استخدم النسخة دي وخلاص:


import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:driver_app/core/constants/storage_keys.dart';

@lazySingleton
class AppInterceptors extends Interceptor {
  AppInterceptors(this._storage);

  final FlutterSecureStorage _storage;

  // روابط من غير توكين (حط الروابط الحقيقية بتاعتك)
  static const List<String> _publicPaths = [
    '/api/auth/signin',
    '/api/auth/signup',
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



ملاحظتين
لما التوكين يتمسح بعد 401، الـ interceptor مش بيودّي اليوزر لشاشة الـ login. ده بتعمله في الـ UI: لما الـ Cubit يستلم error 401 يرجّع اليوزر للـ login.
الـ _publicPaths أهم حاجة تظبطها، لأن لو الـ login رجع 401 على باسورد غلط، الـ path لازم يكون مستثنى عشان ما يتمسحش توكين ملوش لازمة.

*/