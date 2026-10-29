import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/auth/data/model/responses/login_response/login_response.dart';
import 'package:fitness_app/features/auth/data/repo_impl/auth_repo_impl.dart';
import '../../../../helpers/fakes.dart';
import '../../../../helpers/test_data.dart';

void main() {
  late FakeRemoteDataSource fakeRemote;
  late AuthRepoImpl repo;

  setUp(() {
    fakeRemote = FakeRemoteDataSource();
    repo = AuthRepoImpl(fakeRemote);
  });

  group('AuthRepoImpl', () {
    test('builds LoginRequest and returns Success when remote succeeds', () async {
      fakeRemote.nextResponse = TestData.loginResponse;

      final result = await repo.login(
        email: TestData.validEmail,
        password: TestData.validPassword,
      );

      expect(fakeRemote.callCount, 1);
      expect(fakeRemote.lastRequest?.email, TestData.validEmail);
      expect(fakeRemote.lastRequest?.password, TestData.validPassword);
      expect(result, isA<Success<dynamic>>());
      expect((result as Success).data.token, TestData.fakeToken);
    });

    test('returns Error with TimeoutFailure on timeout DioException', () async {
      fakeRemote.nextError = DioException(
        requestOptions: RequestOptions(path: '/signin'),
        type: DioExceptionType.connectionTimeout,
      );

      final result = await repo.login(
        email: TestData.validEmail,
        password: TestData.validPassword,
      );

      expect(result, isA<Error<dynamic>>());
      expect((result as Error).failure, isA<TimeoutFailure>());
    });

    test('returns Error with InternetConnectionFailure on connectionError DioException', () async {
      fakeRemote.nextError = DioException(
        requestOptions: RequestOptions(path: '/signin'),
        type: DioExceptionType.connectionError,
      );

      final result = await repo.login(
        email: TestData.validEmail,
        password: TestData.validPassword,
      );

      expect(result, isA<Error<dynamic>>());
      expect((result as Error).failure, isA<InternetConnectionFailure>());
    });

    test('returns Error with UnauthorizedFailure and serverMessage on 401 badResponse', () async {
      fakeRemote.nextError = DioException(
        requestOptions: RequestOptions(path: '/signin'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/signin'),
          statusCode: 401,
          data: {'message': 'Invalid credentials'},
        ),
      );

      final result = await repo.login(
        email: TestData.validEmail,
        password: TestData.validPassword,
      );

      expect(result, isA<Error<dynamic>>());
      final failure = (result as Error).failure as UnauthorizedFailure;
      expect(failure.serverMessage, 'Invalid credentials');
    });

    test('returns Error with UnknownFailure on non-Dio exception', () async {
      final originalDebugPrint = debugPrint;
      debugPrint = (_, {wrapWidth}) {};

      try {
        fakeRemote.nextError = Exception('Unexpected');

        final result = await repo.login(
          email: TestData.validEmail,
          password: TestData.validPassword,
        );

        expect(result, isA<Error<dynamic>>());
        expect((result as Error).failure, isA<UnknownFailure>());
      } finally {
        debugPrint = originalDebugPrint;
      }
    });

    test(
      'returns Error when the server answers 200 without a token',
      () async {
        fakeRemote.nextResponse = LoginResponse(message: 'ok', token: '');

        final result = await repo.login(
          email: TestData.validEmail,
          password: TestData.validPassword,
        );

        expect(result, isA<Error<dynamic>>());
      },
    );
  });
}
