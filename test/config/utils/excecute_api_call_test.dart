import 'package:dio/dio.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/config/utils/excecute_api_call.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('excecuteApiCall', () {
    test('returns Success when request completes successfully', () async {
      final result = await excecuteApiCall<String>(() async => 'Hello');

      expect(result, isA<Success<String>>());
      expect((result as Success<String>).data, 'Hello');
    });

    test(
      'returns Error with mapped failure when DioException occurs',
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
