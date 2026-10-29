import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/auth/domain/use_cases/login_use_case.dart';
import '../../../../helpers/fakes.dart';
import '../../../../helpers/test_data.dart';

void main() {
  late FakeAuthRepo fakeRepo;
  late LoginUseCase useCase;

  setUp(() {
    fakeRepo = FakeAuthRepo();
    useCase = LoginUseCase(fakeRepo);
  });

  group('LoginUseCase', () {
    test(
      'trims email, does not trim password, and forwards Success result',
      () async {
        fakeRepo.nextResult = Success(TestData.loginEntity);

        final result = await useCase(
          email: '  ${TestData.validEmail}   ',
          password: ' ${TestData.validPassword} ',
        );

        expect(fakeRepo.lastEmail, TestData.validEmail);
        expect(fakeRepo.lastPassword, ' ${TestData.validPassword} ');
        expect(result, isA<Success<dynamic>>());
        expect((result as Success).data, TestData.loginEntity);
      },
    );

    test('forwards Error result from repo untouched', () async {
      fakeRepo.nextResult = const Error(InternetConnectionFailure());

      final result = await useCase(
        email: TestData.validEmail,
        password: TestData.validPassword,
      );

      expect(result, isA<Error<dynamic>>());
      expect((result as Error).failure, isA<InternetConnectionFailure>());
    });
  });
}
