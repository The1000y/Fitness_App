import 'package:dio/dio.dart';
import 'package:fitness_app/config/dio/dio_failure_mapper.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('mapDioExceptionToAppFailure', () {
    final tRequestOptions = RequestOptions(path: '/test');

    test('maps badCertificate to BadCertificateFailure', () {
      final dioException = DioException(
        requestOptions: tRequestOptions,
        type: DioExceptionType.badCertificate,
      );
      expect(
        mapDioExceptionToAppFailure(dioException),
        isA<BadCertificateFailure>(),
      );
    });

    test('maps timeout exceptions to TimeoutFailure', () {
      final types = [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
        DioExceptionType.transformTimeout,
      ];
      for (final type in types) {
        final dioException = DioException(
          requestOptions: tRequestOptions,
          type: type,
        );
        expect(
          mapDioExceptionToAppFailure(dioException),
          isA<TimeoutFailure>(),
        );
      }
    });

    test('maps cancel to CancelFailure', () {
      final dioException = DioException(
        requestOptions: tRequestOptions,
        type: DioExceptionType.cancel,
      );
      expect(mapDioExceptionToAppFailure(dioException), isA<CancelFailure>());
    });

    test('maps connectionError to InternetConnectionFailure', () {
      final dioException = DioException(
        requestOptions: tRequestOptions,
        type: DioExceptionType.connectionError,
      );
      expect(
        mapDioExceptionToAppFailure(dioException),
        isA<InternetConnectionFailure>(),
      );
    });

    test('maps unknown to UnknownFailure', () {
      final dioException = DioException(
        requestOptions: tRequestOptions,
        type: DioExceptionType.unknown,
      );
      expect(mapDioExceptionToAppFailure(dioException), isA<UnknownFailure>());
    });

    group('badResponse status codes and server message extraction', () {
      DioException createBadResponseException(int statusCode, dynamic data) {
        return DioException(
          requestOptions: tRequestOptions,
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: tRequestOptions,
            statusCode: statusCode,
            data: data,
          ),
        );
      }

      test('status 400 maps to BadRequestFailure with extracted message', () {
        final ex = createBadResponseException(400, {
          'message': 'Bad request input',
        });
        final failure = mapDioExceptionToAppFailure(ex);
        expect(failure, isA<BadRequestFailure>());
        expect(
          (failure as BadRequestFailure).serverMessage,
          equals('Bad request input'),
        );
      });

      test(
        'status 401 maps to UnauthorizedFailure with extracted error field',
        () {
          final ex = createBadResponseException(401, {
            'error': 'Invalid token',
          });
          final failure = mapDioExceptionToAppFailure(ex);
          expect(failure, isA<UnauthorizedFailure>());
          expect(
            (failure as UnauthorizedFailure).serverMessage,
            equals('Invalid token'),
          );
        },
      );

      test(
        'status 403 maps to ForbiddenFailure with extracted detail field',
        () {
          final ex = createBadResponseException(403, {
            'detail': 'Access denied',
          });
          final failure = mapDioExceptionToAppFailure(ex);
          expect(failure, isA<ForbiddenFailure>());
          expect(
            (failure as ForbiddenFailure).serverMessage,
            equals('Access denied'),
          );
        },
      );

      test('status 404 maps to NotFoundFailure', () {
        final ex = createBadResponseException(404, null);
        expect(mapDioExceptionToAppFailure(ex), isA<NotFoundFailure>());
      });

      test('status 405 maps to MethodNotAllowedFailure', () {
        final ex = createBadResponseException(405, null);
        expect(mapDioExceptionToAppFailure(ex), isA<MethodNotAllowedFailure>());
      });

      test('status 409 maps to ConflictFailure', () {
        final ex = createBadResponseException(409, {
          'message': 'User already exists',
        });
        final failure = mapDioExceptionToAppFailure(ex);
        expect(failure, isA<ConflictFailure>());
        expect(
          (failure as ConflictFailure).serverMessage,
          equals('User already exists'),
        );
      });

      test('status 422 maps to UnprocessableEntityFailure', () {
        final ex = createBadResponseException(422, {
          'message': 'Validation failed',
        });
        final failure = mapDioExceptionToAppFailure(ex);
        expect(failure, isA<UnprocessableEntityFailure>());
        expect(
          (failure as UnprocessableEntityFailure).serverMessage,
          equals('Validation failed'),
        );
      });

      test('status 429 maps to TooManyRequestsFailure', () {
        final ex = createBadResponseException(429, null);
        expect(mapDioExceptionToAppFailure(ex), isA<TooManyRequestsFailure>());
      });

      test('status 500 maps to ServerFailure with statusCode', () {
        final ex = createBadResponseException(500, null);
        final failure = mapDioExceptionToAppFailure(ex);
        expect(failure, isA<ServerFailure>());
        expect((failure as ServerFailure).statusCode, equals(500));
      });

      test(
        'extracts null serverMessage when data is not a Map or message is empty',
        () {
          final ex = createBadResponseException(400, 'Plain string error');
          final failure = mapDioExceptionToAppFailure(ex);
          expect((failure as BadRequestFailure).serverMessage, isNull);

          final exEmpty = createBadResponseException(400, {'message': ''});
          final failureEmpty = mapDioExceptionToAppFailure(exEmpty);
          expect((failureEmpty as BadRequestFailure).serverMessage, isNull);
        },
      );
    });
  });
}
