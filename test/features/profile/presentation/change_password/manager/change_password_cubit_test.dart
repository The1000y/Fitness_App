import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/config/localization/success_message_enum_mapper.dart';
import 'package:fitness_app/features/profile/domain/entities/params/change_password_param.dart';
import 'package:fitness_app/features/profile/domain/use_cases/profile_change_password_use_case.dart';
import 'package:fitness_app/features/profile/presentation/change_password/manager/change_password_cubit.dart';
import 'package:fitness_app/features/profile/presentation/change_password/manager/change_password_event.dart';
import 'package:fitness_app/features/profile/presentation/change_password/manager/change_password_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileChangePasswordUseCase extends Mock
    implements ProfileChangePasswordUseCase {}

void main() {
  late MockProfileChangePasswordUseCase useCase;

  const event = SubmitChangePasswordEvent(
    oldPassword: 'Old@1234',
    newPassword: 'New@1234',
  );
  const failure = BadRequestFailure(serverMessage: 'Incorrect password');

  setUpAll(() {
    registerFallbackValue(
      const ChangePasswordParam(oldPassword: 'a', newPassword: 'b'),
    );
  });

  setUp(() => useCase = MockProfileChangePasswordUseCase());

  ChangePasswordCubit buildCubit() => ChangePasswordCubit(useCase);

  group('ChangePasswordState', () {
    test('defaultState_isNotLoading', () {
      expect(const ChangePasswordState().isLoading, isFalse);
    });

    test('copyWith_withoutArgs_keepsValue', () {
      const state = ChangePasswordState(
        changePasswordState: BaseState<void>(isLoading: true),
      );

      expect(state.copyWith(), state);
    });

    test('copyWith_replacesValue', () {
      final state = const ChangePasswordState().copyWith(
        changePasswordState: const BaseState<void>(isLoading: true),
      );

      expect(state.isLoading, isTrue);
    });
  });

  group('ChangePasswordCubit', () {
    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'submit_success_emitsLoadingThenIdle',
      build: () {
        when(
          () => useCase(any()),
        ).thenAnswer((_) async => const Success<void>(null));
        return buildCubit();
      },
      act: (cubit) => cubit.doEvent(event),
      expect: () => [
        const ChangePasswordState(
          changePasswordState: BaseState<void>(isLoading: true),
        ),
        const ChangePasswordState(),
      ],
      verify: (_) {
        verify(
          () => useCase(
            const ChangePasswordParam(
              oldPassword: 'Old@1234',
              newPassword: 'New@1234',
            ),
          ),
        ).called(1);
      },
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'submit_failure_emitsLoadingThenErrorState',
      build: () {
        when(
          () => useCase(any()),
        ).thenAnswer((_) async => const Error<void>(failure));
        return buildCubit();
      },
      act: (cubit) => cubit.doEvent(event),
      expect: () => [
        const ChangePasswordState(
          changePasswordState: BaseState<void>(isLoading: true),
        ),
        const ChangePasswordState(
          changePasswordState: BaseState<void>(errorMessage: failure),
        ),
      ],
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'submit_whileLoading_isIgnored',
      build: buildCubit,
      seed: () => const ChangePasswordState(
        changePasswordState: BaseState<void>(isLoading: true),
      ),
      act: (cubit) => cubit.doEvent(event),
      expect: () => <ChangePasswordState>[],
      verify: (_) => verifyNever(() => useCase(any())),
    );

    test('submit_success_emitsSuccessMessageThenPop', () async {
      when(
        () => useCase(any()),
      ).thenAnswer((_) async => const Success<void>(null));
      final cubit = buildCubit();
      final events = <BaseUiEvent>[];
      final sub = cubit.uiEventStream.listen(events.add);

      await cubit.doEvent(event);
      await Future<void>.delayed(Duration.zero);

      expect(events, hasLength(2));
      expect(
        events[0],
        isA<ShowSuccessMessage>().having(
          (e) => e.message,
          'message',
          AppSuccessMessage.passwordChanged,
        ),
      );
      expect(events[1], isA<PopRoute>());

      await sub.cancel();
      await cubit.close();
    });

    test('submit_failure_emitsFailureMessageOnly', () async {
      when(
        () => useCase(any()),
      ).thenAnswer((_) async => const Error<void>(failure));
      final cubit = buildCubit();
      final events = <BaseUiEvent>[];
      final sub = cubit.uiEventStream.listen(events.add);

      await cubit.doEvent(event);
      await Future<void>.delayed(Duration.zero);

      expect(events, hasLength(1));
      expect(
        events.single,
        isA<ShowFailureMessage>().having((e) => e.failure, 'failure', failure),
      );

      await sub.cancel();
      await cubit.close();
    });
  });
}
