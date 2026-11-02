import 'package:dio/dio.dart';
import 'package:fitness_app/config/dio/dio_failure_mapper.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('mapDioExceptionToAppFailure', () {
    DioException createDioException({
      required DioExceptionType type,
      int? statusCode,
      dynamic responseData,
    }) {
      final requestOptions = RequestOptions(path: '/test');
      return DioException(
        requestOptions: requestOptions,
        type: type,
        response: statusCode != null
            ? Response(
                requestOptions: requestOptions,
                statusCode: statusCode,
                data: responseData,
              )
            : null,
      );
    }

    test('maps timeout exceptions to TimeoutFailure', () {
      for (final type in [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
        DioExceptionType.transformTimeout,
      ]) {
        final failure = mapDioExceptionToAppFailure(
          createDioException(type: type),
        );
        expect(failure, isA<TimeoutFailure>());
      }
    });

    test('maps connectionError to InternetConnectionFailure', () {
      final failure = mapDioExceptionToAppFailure(
        createDioException(type: DioExceptionType.connectionError),
      );
      expect(failure, isA<InternetConnectionFailure>());
    });

    test('maps cancel to CancelFailure', () {
      final failure = mapDioExceptionToAppFailure(
        createDioException(type: DioExceptionType.cancel),
      );
      expect(failure, isA<CancelFailure>());
    });

    test('maps badCertificate to BadCertificateFailure', () {
      final failure = mapDioExceptionToAppFailure(
        createDioException(type: DioExceptionType.badCertificate),
      );
      expect(failure, isA<BadCertificateFailure>());
    });

    test('maps unknown to UnknownFailure', () {
      final failure = mapDioExceptionToAppFailure(
        createDioException(type: DioExceptionType.unknown),
      );
      expect(failure, isA<UnknownFailure>());
    });

    group('badResponse status codes', () {
      test('400 maps to BadRequestFailure with extracted message', () {
        final failure = mapDioExceptionToAppFailure(
          createDioException(
            type: DioExceptionType.badResponse,
            statusCode: 400,
            responseData: {'message': 'Bad input data'},
          ),
        );
        expect(failure, isA<BadRequestFailure>());
        expect((failure as BadRequestFailure).serverMessage, 'Bad input data');
      });

      test('401 maps to UnauthorizedFailure with extracted message', () {
        final failure = mapDioExceptionToAppFailure(
          createDioException(
            type: DioExceptionType.badResponse,
            statusCode: 401,
            responseData: {'error': 'Invalid credentials'},
          ),
        );
        expect(failure, isA<UnauthorizedFailure>());
        expect(
          (failure as UnauthorizedFailure).serverMessage,
          'Invalid credentials',
        );
      });

      test('403 maps to ForbiddenFailure with extracted message', () {
        final failure = mapDioExceptionToAppFailure(
          createDioException(
            type: DioExceptionType.badResponse,
            statusCode: 403,
            responseData: {'detail': 'Access denied'},
          ),
        );
        expect(failure, isA<ForbiddenFailure>());
        expect((failure as ForbiddenFailure).serverMessage, 'Access denied');
      });

      test('404 maps to NotFoundFailure', () {
        final failure = mapDioExceptionToAppFailure(
          createDioException(
            type: DioExceptionType.badResponse,
            statusCode: 404,
          ),
        );
        expect(failure, isA<NotFoundFailure>());
      });

      test('405 maps to MethodNotAllowedFailure', () {
        final failure = mapDioExceptionToAppFailure(
          createDioException(
            type: DioExceptionType.badResponse,
            statusCode: 405,
          ),
        );
        expect(failure, isA<MethodNotAllowedFailure>());
      });

      test('409 maps to ConflictFailure with extracted message', () {
        final failure = mapDioExceptionToAppFailure(
          createDioException(
            type: DioExceptionType.badResponse,
            statusCode: 409,
            responseData: {'message': 'User already exists'},
          ),
        );
        expect(failure, isA<ConflictFailure>());
        expect(
          (failure as ConflictFailure).serverMessage,
          'User already exists',
        );
      });

      test('422 maps to UnprocessableEntityFailure with extracted message', () {
        final failure = mapDioExceptionToAppFailure(
          createDioException(
            type: DioExceptionType.badResponse,
            statusCode: 422,
            responseData: {'message': 'Validation failed'},
          ),
        );
        expect(failure, isA<UnprocessableEntityFailure>());
        expect(
          (failure as UnprocessableEntityFailure).serverMessage,
          'Validation failed',
        );
      });

      test('429 maps to TooManyRequestsFailure', () {
        final failure = mapDioExceptionToAppFailure(
          createDioException(
            type: DioExceptionType.badResponse,
            statusCode: 429,
          ),
        );
        expect(failure, isA<TooManyRequestsFailure>());
      });

      test('500 maps to ServerFailure with statusCode', () {
        final failure = mapDioExceptionToAppFailure(
          createDioException(
            type: DioExceptionType.badResponse,
            statusCode: 500,
          ),
        );
        expect(failure, isA<ServerFailure>());
        expect((failure as ServerFailure).statusCode, 500);
      });
    });
  });
}
