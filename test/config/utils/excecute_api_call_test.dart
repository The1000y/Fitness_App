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

    test('returns Error<T> when request throws DioException', () async {
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
    });

    test('returns Error<T> with UnknownFailure on generic Exception', () async {
      final result = await excecuteApiCall<String>(() async {
        throw FormatException('Malformed JSON');
      });

      expect(result, isA<Error<String>>());
      expect((result as Error<String>).failure, isA<UnknownFailure>());
    });
  });
}
