import 'package:dio/dio.dart';
import 'package:fitness_app/config/dio/app_interceptor.dart';
import 'package:fitness_app/core/constants/api_strings.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@module
abstract class DioModule {
  @Named(ApiStrings.namedFitnessDio)
  @lazySingleton
  Dio fitnessDio(AppInterceptors appInterceptors) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiStrings.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
    dio.interceptors.add(appInterceptors);

    _addLogger(dio);
    return dio;
  }

  @Named(ApiStrings.namedMealDio)
  @lazySingleton
  Dio mealDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiStrings.mealBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    _addLogger(dio);
    return dio;
  }

  void _addLogger(Dio dio) {
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          error: true,
          compact: true,
        ),
      );
    }
  }
}
