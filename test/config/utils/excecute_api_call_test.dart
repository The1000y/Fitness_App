import 'package:dio/dio.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/config/utils/excecute_api_call.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('excecuteApiCall', () {
    test('returns Success<T> when request succeeds', () async {
      final result = await excecuteApiCall(() async => 'test_data');

      expect(result, isA<Success<String>>());
      expect((result as Success<String>).data, equals('test_data'));
    });

    test(
      'returns Error<T> when request throws DioException (connectionError)',
      () async {
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/api'),
          type: DioExceptionType.connectionError,
        );

        final result = await excecuteApiCall<String>(() async {
          throw dioException;
        });

        expect(result, isA<Error<String>>());
        expect(
          (result as Error<String>).failure,
          isA<InternetConnectionFailure>(),
        );
      },
    );

    test(
      'returns Error with mapped failure when DioException (connectionTimeout) occurs',
      () async {
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.connectionTimeout,
        );

        final result = await excecuteApiCall<String>(() async {
          throw dioException;
        });

        expect(result, isA<Error<String>>());
        expect((result as Error<String>).failure, isA<TimeoutFailure>());
      },
    );

    test('returns Error<T> with UnknownFailure on generic Exception', () async {
      final result = await excecuteApiCall<String>(() async {
        throw FormatException('Malformed JSON');
      });

      expect(result, isA<Error<String>>());
      expect((result as Error<String>).failure, isA<UnknownFailure>());
    });

    test(
      'returns Error with UnknownFailure when unexpected exception occurs',
      () async {
        final result = await excecuteApiCall<String>(() async {
          throw StateError('Unexpected crash');
        });

        expect(result, isA<Error<String>>());
        expect((result as Error<String>).failure, isA<UnknownFailure>());
      },
    );
  });
}
