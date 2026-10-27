import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/config/routing/app_routes.dart';
import 'package:fitness_app/features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:fitness_app/features/auth/domain/use_cases/login_use_case.dart';
import 'package:fitness_app/features/auth/presentation/login/manager/login_cubit.dart';
import 'package:fitness_app/features/auth/presentation/login/manager/login_event.dart';
import 'package:fitness_app/features/auth/presentation/login/manager/login_state.dart';
import '../../../../../helpers/fakes.dart';
import '../../../../../helpers/test_data.dart';

void main() {
  late FakeAuthRepo fakeRepo;
  late LoginUseCase useCase;
  late LoginCubit cubit;

  setUp(() {
    fakeRepo = FakeAuthRepo();
    useCase = LoginUseCase(fakeRepo);
    cubit = LoginCubit(useCase);
  });

  tearDown(() {
    cubit.close();
  });

  group('LoginCubit', () {
    test('initial state is LoginState()', () {
      expect(cubit.state, const LoginState());
    });

    test('successful login emits isLoading true/false and NavigateReplaceTo(AppRoutes.home)', () async {
      fakeRepo.nextResult = Success(TestData.loginEntity);

      final uiEvents = <BaseUiEvent>[];
      cubit.uiEventStream.listen(uiEvents.add);

      final states = <LoginState>[];
      cubit.stream.listen(states.add);

      cubit.onEvent(
        const LoginSubmitted(
          email: '  ${TestData.validEmail}  ',
          password: TestData.validPassword,
        ),
      );

      await Future.delayed(const Duration(milliseconds: 50));

      expect(fakeRepo.lastEmail, TestData.validEmail);
      expect(states.map((s) => s.isLoading).toList(), [true, false]);
      expect(uiEvents, [const NavigateReplaceTo(AppRoutes.home)]);
    });

    test('failed login emits isLoading true/false and ShowFailureMessage', () async {
      const failure = UnauthorizedFailure(serverMessage: 'Wrong password');
      fakeRepo.nextResult = const Error(failure);

      final uiEvents = <BaseUiEvent>[];
      cubit.uiEventStream.listen(uiEvents.add);

      cubit.onEvent(
        const LoginSubmitted(
          email: TestData.validEmail,
          password: TestData.validPassword,
        ),
      );

      await Future.delayed(const Duration(milliseconds: 50));

      expect(uiEvents.length, 1);
      final event = uiEvents.first as ShowFailureMessage;
      expect(event.failure, failure);
    });

    test('second LoginSubmitted while loading is ignored (repo called once)', () async {
      final completer = Completer<BaseResponse<LoginEntity>>();
      fakeRepo.completer = completer;

      cubit.onEvent(
        const LoginSubmitted(
          email: TestData.validEmail,
          password: TestData.validPassword,
        ),
      );
      await pumpEventQueue();

      expect(fakeRepo.callCount, 1);

      cubit.onEvent(
        const LoginSubmitted(
          email: 'other@example.com',
          password: TestData.validPassword,
        ),
      );
      await pumpEventQueue();

      expect(fakeRepo.callCount, 1);

      completer.complete(Success(TestData.loginEntity));
      await pumpEventQueue();
    });

    test('after a failure the user can submit again', () async {
      fakeRepo.nextResult = const Error(InternetConnectionFailure());
      cubit.onEvent(
        const LoginSubmitted(
          email: TestData.validEmail,
          password: TestData.validPassword,
        ),
      );
      await pumpEventQueue();
      expect(fakeRepo.callCount, 1);

      fakeRepo.nextResult = Success(TestData.loginEntity);
      cubit.onEvent(
        const LoginSubmitted(
          email: TestData.validEmail,
          password: TestData.validPassword,
        ),
      );
      await pumpEventQueue();
      expect(fakeRepo.callCount, 2);
    });

    test(
      'closing cubit while request is pending, then completing it, throws nothing and emits nothing',
      () async {
        final completer = Completer<BaseResponse<LoginEntity>>();
        fakeRepo.completer = completer;

        cubit.onEvent(
          const LoginSubmitted(
            email: TestData.validEmail,
            password: TestData.validPassword,
          ),
        );
        await pumpEventQueue();

        await cubit.close();

        expect(() => completer.complete(Success(TestData.loginEntity)), returnsNormally);
      },
    );
  });
}
