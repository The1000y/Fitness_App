import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/config/localization/success_message_enum_mapper.dart';
import 'package:fitness_app/config/routing/app_routes.dart';
import 'package:fitness_app/features/auth/domain/entities/params/forget_password_param.dart';
import 'package:fitness_app/features/auth/domain/entities/params/reset_password_param.dart';
import 'package:fitness_app/features/auth/domain/entities/params/verify_otp_param.dart';
import 'package:fitness_app/features/auth/domain/use_cases/forget_password_user_case.dart';
import 'package:fitness_app/features/auth/domain/use_cases/reset_password_user_case.dart';
import 'package:fitness_app/features/auth/domain/use_cases/verify_otp_user_case.dart';
import 'package:fitness_app/features/auth/presentation/forget_password/manager/forget_password_cubit.dart';
import 'package:fitness_app/features/auth/presentation/forget_password/manager/forget_password_event.dart';
import 'package:fitness_app/features/auth/presentation/forget_password/manager/forget_password_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockForgetPasswordUserCase extends Mock implements ForgetPasswordUserCase {}
class MockVerifyOtpUserCase extends Mock implements VerifyOtpUserCase {}
class MockResetPasswordUserCase extends Mock implements ResetPasswordUserCase {}

void main() {
  late MockForgetPasswordUserCase mockForgetPasswordUseCase;
  late MockVerifyOtpUserCase mockVerifyOtpUseCase;
  late MockResetPasswordUserCase mockResetPasswordUseCase;

  setUpAll(() {
    registerFallbackValue(const ForgetPasswordParam(email: 'fallback@example.com'));
    registerFallbackValue(const VerifyOtpParam('0000'));
    registerFallbackValue(
      const ResetPasswordParam(
        email: 'fallback@example.com',
        password: 'Password1!',
      ),
    );
  });

  setUp(() {
    mockForgetPasswordUseCase = MockForgetPasswordUserCase();
    mockVerifyOtpUseCase = MockVerifyOtpUserCase();
    mockResetPasswordUseCase = MockResetPasswordUserCase();
  });

  ForgetPasswordCubit buildCubit() {
    return ForgetPasswordCubit(
      mockForgetPasswordUseCase,
      mockVerifyOtpUseCase,
      mockResetPasswordUseCase,
    );
  }

  group('ForgetPasswordCubit', () {
    test('initial state has default empty BaseStates', () {
      final cubit = buildCubit();
      expect(cubit.state, equals(const ForgetPasswordState()));
      expect(cubit.state.forgetPasswordState.isLoading, isFalse);
      expect(cubit.state.verifyOtpState.isLoading, isFalse);
      expect(cubit.state.resetPasswordState.isLoading, isFalse);
      cubit.close();
    });

    group('SendCodeEvent', () {
      const tEmail = 'user@example.com';

      blocTest<ForgetPasswordCubit, ForgetPasswordState>(
        'emits [isLoading: true, isLoading: false, data: null] and UI events on success',
        build: () {
          when(() => mockForgetPasswordUseCase.call(any()))
              .thenAnswer((_) async => const Success<void>(null));
          return buildCubit();
        },
        act: (cubit) async {
          final uiEvents = <BaseUiEvent>[];
          final sub = cubit.uiEventStream.listen(uiEvents.add);

          await cubit.doEvent(const SendCodeEvent(tEmail));
          await Future.delayed(Duration.zero);

          expect(uiEvents.length, equals(2));
          expect(uiEvents[0], isA<ShowSuccessMessage>());
          expect(
            (uiEvents[0] as ShowSuccessMessage).message,
            equals(AppSuccessMessage.otpSentSuccessfully),
          );
          expect(uiEvents[1], isA<NavigateTo>());
          expect((uiEvents[1] as NavigateTo).routeName, equals(AppRoutes.otpVerification));

          await sub.cancel();
        },
        expect: () => [
          const ForgetPasswordState(
            forgetPasswordState: BaseState<void>(isLoading: true),
          ),
          const ForgetPasswordState(
            forgetPasswordState: BaseState<void>(isLoading: false),
          ),
        ],
        verify: (_) {
          verify(
            () => mockForgetPasswordUseCase.call(
              any(that: isA<ForgetPasswordParam>().having((p) => p.email, 'email', tEmail)),
            ),
          ).called(1);
        },
      );

      blocTest<ForgetPasswordCubit, ForgetPasswordState>(
        'emits [isLoading: true, errorMessage: failure] and ShowFailureMessage on error',
        build: () {
          when(() => mockForgetPasswordUseCase.call(any()))
              .thenAnswer((_) async => const Error<void>(InternetConnectionFailure()));
          return buildCubit();
        },
        act: (cubit) async {
          final uiEvents = <BaseUiEvent>[];
          final sub = cubit.uiEventStream.listen(uiEvents.add);

          await cubit.doEvent(const SendCodeEvent(tEmail));
          await Future.delayed(Duration.zero);

          expect(uiEvents.length, equals(1));
          expect(uiEvents[0], isA<ShowFailureMessage>());
          expect(
            (uiEvents[0] as ShowFailureMessage).failure,
            isA<InternetConnectionFailure>(),
          );

          await sub.cancel();
        },
        expect: () => [
          const ForgetPasswordState(
            forgetPasswordState: BaseState<void>(isLoading: true),
          ),
          const ForgetPasswordState(
            forgetPasswordState: BaseState<void>(
              isLoading: false,
              errorMessage: InternetConnectionFailure(),
            ),
          ),
        ],
      );

      test('does not trigger useCase if forgetPasswordState is already loading', () async {
        final cubit = buildCubit();
        cubit.emit(
          cubit.state.copyWith(
            forgetPasswordState: cubit.state.forgetPasswordState.copyWith(isLoading: true),
          ),
        );

        await cubit.doEvent(const SendCodeEvent(tEmail));

        verifyZeroInteractions(mockForgetPasswordUseCase);
        await cubit.close();
      });
    });

    group('VerifyOtpEvent', () {
      const tCode = '1234';

      blocTest<ForgetPasswordCubit, ForgetPasswordState>(
        'emits [isLoading: true, isLoading: false] and NavigateTo(createPassword) on success',
        build: () {
          when(() => mockVerifyOtpUseCase.call(any()))
              .thenAnswer((_) async => const Success<void>(null));
          return buildCubit();
        },
        act: (cubit) async {
          final uiEvents = <BaseUiEvent>[];
          final sub = cubit.uiEventStream.listen(uiEvents.add);

          await cubit.doEvent(const VerifyOtpEvent(tCode));
          await Future.delayed(Duration.zero);

          expect(uiEvents.length, equals(1));
          expect(uiEvents[0], isA<NavigateTo>());
          expect((uiEvents[0] as NavigateTo).routeName, equals(AppRoutes.createPassword));

          await sub.cancel();
        },
        expect: () => [
          const ForgetPasswordState(
            verifyOtpState: BaseState<void>(isLoading: true),
          ),
          const ForgetPasswordState(
            verifyOtpState: BaseState<void>(isLoading: false),
          ),
        ],
        verify: (_) {
          verify(
            () => mockVerifyOtpUseCase.call(
              any(that: isA<VerifyOtpParam>().having((p) => p.resetCode, 'resetCode', tCode)),
            ),
          ).called(1);
        },
      );

      blocTest<ForgetPasswordCubit, ForgetPasswordState>(
        'emits [isLoading: true, errorMessage: failure] and ShowFailureMessage on error',
        build: () {
          when(() => mockVerifyOtpUseCase.call(any()))
              .thenAnswer((_) async => const Error<void>(BadRequestFailure(serverMessage: 'Invalid code')));
          return buildCubit();
        },
        act: (cubit) async {
          final uiEvents = <BaseUiEvent>[];
          final sub = cubit.uiEventStream.listen(uiEvents.add);

          await cubit.doEvent(const VerifyOtpEvent(tCode));
          await Future.delayed(Duration.zero);

          expect(uiEvents.length, equals(1));
          expect(uiEvents[0], isA<ShowFailureMessage>());

          await sub.cancel();
        },
        expect: () => [
          const ForgetPasswordState(
            verifyOtpState: BaseState<void>(isLoading: true),
          ),
          const ForgetPasswordState(
            verifyOtpState: BaseState<void>(
              isLoading: false,
              errorMessage: BadRequestFailure(serverMessage: 'Invalid code'),
            ),
          ),
        ],
      );

      test('does not trigger useCase if verifyOtpState is already loading', () async {
        final cubit = buildCubit();
        cubit.emit(
          cubit.state.copyWith(
            verifyOtpState: cubit.state.verifyOtpState.copyWith(isLoading: true),
          ),
        );

        await cubit.doEvent(const VerifyOtpEvent(tCode));

        verifyZeroInteractions(mockVerifyOtpUseCase);
        await cubit.close();
      });
    });

    group('ResetPasswordEvent', () {
      const tNewPassword = 'Password123!';

      test('does not call resetPasswordUseCase if email was not stored', () async {
        final cubit = buildCubit();

        await cubit.doEvent(const ResetPasswordEvent(tNewPassword));

        verifyZeroInteractions(mockResetPasswordUseCase);
        await cubit.close();
      });

      blocTest<ForgetPasswordCubit, ForgetPasswordState>(
        'resets password successfully when email was stored via SendCodeEvent',
        build: () {
          when(() => mockForgetPasswordUseCase.call(any()))
              .thenAnswer((_) async => const Success<void>(null));
          when(() => mockResetPasswordUseCase.call(any()))
              .thenAnswer((_) async => const Success<void>(null));
          return buildCubit();
        },
        act: (cubit) async {
          final uiEvents = <BaseUiEvent>[];
          final sub = cubit.uiEventStream.listen(uiEvents.add);

          // First store email via SendCodeEvent
          await cubit.doEvent(const SendCodeEvent('stored@example.com'));

          // Now reset password
          await cubit.doEvent(const ResetPasswordEvent(tNewPassword));
          await Future.delayed(Duration.zero);

          expect(
            uiEvents.any(
              (e) =>
                  e is ShowSuccessMessage &&
                  e.message == AppSuccessMessage.passwordChanged,
            ),
            isTrue,
          );
          expect(
            uiEvents.any(
              (e) =>
                  e is NavigateAndRemoveUntil && e.routeName == AppRoutes.login,
            ),
            isTrue,
          );

          await sub.cancel();
        },
        expect: () => [
          const ForgetPasswordState(
            forgetPasswordState: BaseState<void>(isLoading: true),
          ),
          const ForgetPasswordState(
            forgetPasswordState: BaseState<void>(isLoading: false),
          ),
          const ForgetPasswordState(
            resetPasswordState: BaseState<void>(isLoading: true),
          ),
          const ForgetPasswordState(
            resetPasswordState: BaseState<void>(isLoading: false),
          ),
        ],
        verify: (_) {
          verify(
            () => mockResetPasswordUseCase.call(
              any(
                that: isA<ResetPasswordParam>()
                    .having((p) => p.email, 'email', 'stored@example.com')
                    .having((p) => p.password, 'password', tNewPassword),
              ),
            ),
          ).called(1);
        },
      );

      blocTest<ForgetPasswordCubit, ForgetPasswordState>(
        'emits error state and ShowFailureMessage on reset failure',
        build: () {
          when(() => mockForgetPasswordUseCase.call(any()))
              .thenAnswer((_) async => const Success<void>(null));
          when(() => mockResetPasswordUseCase.call(any()))
              .thenAnswer((_) async => const Error<void>(ServerFailure(statusCode: 500)));
          return buildCubit();
        },
        act: (cubit) async {
          final uiEvents = <BaseUiEvent>[];
          final sub = cubit.uiEventStream.listen(uiEvents.add);

          await cubit.doEvent(const SendCodeEvent('stored@example.com'));
          await cubit.doEvent(const ResetPasswordEvent(tNewPassword));
          await Future.delayed(Duration.zero);

          expect(
            uiEvents.any(
              (e) =>
                  e is ShowFailureMessage &&
                  e.failure == const ServerFailure(statusCode: 500),
            ),
            isTrue,
          );

          await sub.cancel();
        },
        expect: () => [
          const ForgetPasswordState(
            forgetPasswordState: BaseState<void>(isLoading: true),
          ),
          const ForgetPasswordState(
            forgetPasswordState: BaseState<void>(isLoading: false),
          ),
          const ForgetPasswordState(
            resetPasswordState: BaseState<void>(isLoading: true),
          ),
          const ForgetPasswordState(
            resetPasswordState: BaseState<void>(
              isLoading: false,
              errorMessage: ServerFailure(statusCode: 500),
            ),
          ),
        ],
      );
    });
  });
}
