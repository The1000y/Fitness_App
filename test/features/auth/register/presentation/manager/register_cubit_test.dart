import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/auth/domain/entities/params/register_params_entity.dart';
import 'package:fitness_app/features/auth/domain/entities/register_entity/register_response_entity.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_cubit.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_event.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_option.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_state.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_ui_event.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/register_test_helpers.dart';

void main() {
  late MockRegisterUseCase useCase;

  setUpAll(() {
    registerFallbackValue(buildRegisterParams());
  });

  setUp(() {
    useCase = MockRegisterUseCase();
  });

  RegisterCubit createCubit({BaseResponse<RegisterResponeEntity>? response}) {
    when(() => useCase(any())).thenAnswer(
      (_) async => response ?? Success(RegisterResponeEntity(message: 'ok')),
    );
    return RegisterCubit(ucase: useCase);
  }

  group('field updates', () {
    blocTest<RegisterCubit, RegisterState>(
      'stores the submitted credentials',
      build: createCubit,
      act: (cubit) => cubit.doEvent(
        SubmitEvent(
          firstName: 'Ahmed',
          lastName: 'Ali',
          email: 'ahmed@example.com',
          password: 'Password1!',
        ),
      ),
      expect: () => [
        const RegisterState(
          data: RegisterFormData(
            firstName: 'Ahmed',
            lastName: 'Ali',
            email: 'ahmed@example.com',
            password: 'Password1!',
          ),
        ),
      ],
    );

    blocTest<RegisterCubit, RegisterState>(
      'stores the selected gender',
      build: createCubit,
      act: (cubit) => cubit.doEvent(const GenderSelectedEvent(Gender.female)),
      expect: () => [
        const RegisterState(data: RegisterFormData(gender: Gender.female)),
      ],
    );

    blocTest<RegisterCubit, RegisterState>(
      'stores the selected age',
      build: createCubit,
      act: (cubit) => cubit.doEvent(const AgeChangedEvent(32)),
      expect: () => [const RegisterState(data: RegisterFormData(age: 32))],
    );

    blocTest<RegisterCubit, RegisterState>(
      'stores the selected weight',
      build: createCubit,
      act: (cubit) => cubit.doEvent(const WeightChangedEvent(75)),
      expect: () => [const RegisterState(data: RegisterFormData(weight: 75))],
    );

    blocTest<RegisterCubit, RegisterState>(
      'stores the selected height',
      build: createCubit,
      act: (cubit) => cubit.doEvent(const HeightChangedEvent(182)),
      expect: () => [const RegisterState(data: RegisterFormData(height: 182))],
    );

    blocTest<RegisterCubit, RegisterState>(
      'stores the selected goal',
      build: createCubit,
      act: (cubit) => cubit.doEvent(const GoalSelectedEvent(Goal.getFitter)),
      expect: () => [
        const RegisterState(data: RegisterFormData(goal: Goal.getFitter)),
      ],
    );

    blocTest<RegisterCubit, RegisterState>(
      'stores the selected activity level',
      build: createCubit,
      act: (cubit) => cubit.doEvent(
        const ActivityLevelSelectedEvent(ActivityLevel.advance),
      ),
      expect: () => [
        const RegisterState(
          data: RegisterFormData(activityLevel: ActivityLevel.advance),
        ),
      ],
    );
  });

  group('step navigation', () {
    blocTest<RegisterCubit, RegisterState>(
      'does not advance without a gender',
      build: createCubit,
      act: (cubit) => cubit.doEvent(const NextStepEvent()),
      expect: () => <RegisterState>[],
    );

    blocTest<RegisterCubit, RegisterState>(
      'advances to the next step when the current step is valid',
      build: createCubit,
      seed: () =>
          const RegisterState(data: RegisterFormData(gender: Gender.male)),
      act: (cubit) => cubit.doEvent(const NextStepEvent()),
      expect: () => [
        const RegisterState(
          data: RegisterFormData(gender: Gender.male, step: 1),
        ),
      ],
    );

    blocTest<RegisterCubit, RegisterState>(
      'does not advance while loading',
      build: createCubit,
      seed: () => const RegisterState(
        isLoading: true,
        data: RegisterFormData(gender: Gender.male),
      ),
      act: (cubit) => cubit.doEvent(const NextStepEvent()),
      expect: () => <RegisterState>[],
    );

    blocTest<RegisterCubit, RegisterState>(
      'does not advance on the goal step without a goal',
      build: createCubit,
      seed: () => const RegisterState(
        data: RegisterFormData(step: 4, gender: Gender.male),
      ),
      act: (cubit) => cubit.doEvent(const NextStepEvent()),
      expect: () => <RegisterState>[],
    );

    blocTest<RegisterCubit, RegisterState>(
      'moves back from a step to the previous one',
      build: createCubit,
      seed: () => const RegisterState(
        data: RegisterFormData(step: 2, gender: Gender.male),
      ),
      act: (cubit) => cubit.doEvent(const PreviousStepEvent()),
      expect: () => [
        const RegisterState(
          data: RegisterFormData(step: 1, gender: Gender.male),
        ),
      ],
    );

    blocTest<RegisterCubit, RegisterState>(
      'does not change state when going back from the first step',
      build: createCubit,
      seed: () =>
          const RegisterState(data: RegisterFormData(gender: Gender.male)),
      act: (cubit) => cubit.doEvent(const PreviousStepEvent()),
      expect: () => <RegisterState>[],
    );

    blocTest<RegisterCubit, RegisterState>(
      'does not go back while loading',
      build: createCubit,
      seed: () => const RegisterState(
        isLoading: true,
        data: RegisterFormData(step: 2, gender: Gender.male),
      ),
      act: (cubit) => cubit.doEvent(const PreviousStepEvent()),
      expect: () => <RegisterState>[],
    );
  });

  group('submission', () {
    const form = RegisterFormData(
      firstName: ' Ahmed ',
      lastName: ' Ali ',
      email: ' ahmed@example.com ',
      password: 'Password1!',
      step: 5,
      gender: Gender.male,
      age: 31,
      weight: 82,
      height: 180,
      goal: Goal.loseWeight,
      activityLevel: ActivityLevel.intermediate,
    );

    blocTest<RegisterCubit, RegisterState>(
      'emits loading and success states and sends a trimmed request',
      build: createCubit,
      seed: () => const RegisterState(data: form),
      act: (cubit) => cubit.doEvent(const NextStepEvent()),
      expect: () => [
        const RegisterState(isLoading: true, data: form),
        const RegisterState(data: form),
      ],
      verify: (_) {
        final request =
            verify(() => useCase(captureAny())).captured.single
                as RegisterParams;

        expect(request.firstName, 'Ahmed');
        expect(request.lastName, 'Ali');
        expect(request.email, 'ahmed@example.com');
        expect(request.password, 'Password1!');
        expect(request.rePassword, 'Password1!');
        expect(request.gender, 'male');
        expect(request.age, 31);
        expect(request.weight, 82);
        expect(request.height, 180);
        expect(request.goal, 'Lose weight');
        expect(request.activityLevel, 'level3');
      },
    );

    blocTest<RegisterCubit, RegisterState>(
      'emits loading and failure states when the request fails',
      build: () => createCubit(
        response: const Error<RegisterResponeEntity>(
          BadRequestFailure(serverMessage: 'Email already exists'),
        ),
      ),
      seed: () => const RegisterState(
        data: RegisterFormData(
          step: 5,
          gender: Gender.male,
          goal: Goal.getFitter,
        ),
      ),
      act: (cubit) => cubit.doEvent(const NextStepEvent()),
      expect: () => [
        const RegisterState(
          isLoading: true,
          data: RegisterFormData(
            step: 5,
            gender: Gender.male,
            goal: Goal.getFitter,
          ),
        ),
        const RegisterState(
          errorMessage: BadRequestFailure(
            serverMessage: 'Email already exists',
          ),
          data: RegisterFormData(
            step: 5,
            gender: Gender.male,
            goal: Goal.getFitter,
          ),
        ),
      ],
    );
  });

  group('UI events', () {
    test('emits AcceptFirstUiEvent after credentials are submitted', () async {
      final cubit = createCubit();
      addTearDown(cubit.close);

      final event = expectLater(
        cubit.uiEventStream,
        emits(isA<AcceptFirstUiEvent>()),
      );

      await cubit.doEvent(
        SubmitEvent(
          firstName: 'Ahmed',
          lastName: 'Ali',
          email: 'ahmed@example.com',
          password: 'Password1!',
        ),
      );

      await event;
    });

    test('emits StepChangedUiEvent when advancing', () async {
      final cubit = createCubit();
      addTearDown(cubit.close);
      await cubit.doEvent(const GenderSelectedEvent(Gender.male));

      final event = expectLater(
        cubit.uiEventStream,
        emits(
          isA<StepChangedUiEvent>().having((event) => event.step, 'step', 1),
        ),
      );

      await cubit.doEvent(const NextStepEvent());

      await event;
    });

    test('emits BackToCredentialsUiEvent from the first step', () async {
      final cubit = createCubit();
      addTearDown(cubit.close);

      final event = expectLater(
        cubit.uiEventStream,
        emits(isA<BackToCredentialsUiEvent>()),
      );

      await cubit.doEvent(const PreviousStepEvent());

      await event;
    });
  });
}
