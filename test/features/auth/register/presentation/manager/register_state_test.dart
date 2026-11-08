import 'package:fitness_app/features/auth/presentation/register/manager/register_option.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RegisterFormData defaults', () {
    test('starts empty with the expected measurement defaults', () {
      const form = RegisterFormData();

      expect(form.firstName, isEmpty);
      expect(form.lastName, isEmpty);
      expect(form.email, isEmpty);
      expect(form.password, isEmpty);
      expect(form.step, 0);
      expect(form.gender, isNull);
      expect(form.age, 25);
      expect(form.weight, 90);
      expect(form.height, 167);
      expect(form.goal, isNull);
      expect(form.activityLevel, ActivityLevel.rookie);
    });

    test('isLastStep is true only for the final step', () {
      expect(const RegisterFormData(step: 4).isLastStep, isFalse);
      expect(const RegisterFormData(step: 5).isLastStep, isTrue);
      expect(
        const RegisterFormData(step: RegisterFormData.totalSteps).isLastStep,
        isFalse,
      );
    });
  });

  group('RegisterFormData.canProceed', () {
    test('requires a gender on step 0', () {
      expect(const RegisterFormData().canProceed, isFalse);
      expect(const RegisterFormData(gender: Gender.male).canProceed, isTrue);
    });

    test('requires a goal on step 4', () {
      expect(const RegisterFormData(step: 4).canProceed, isFalse);
      expect(
        const RegisterFormData(step: 4, goal: Goal.loseWeight).canProceed,
        isTrue,
      );
    });

    test('allows steps that have no required selection', () {
      for (final step in [1, 2, 3, 5]) {
        expect(
          RegisterFormData(step: step).canProceed,
          isTrue,
          reason: 'step $step should be allowed',
        );
      }
    });
  });

  group('RegisterFormData.copyWith', () {
    test('updates every provided field', () {
      const original = RegisterFormData();
      final updated = original.copyWith(
        firstName: 'Ahmed',
        lastName: 'Ali',
        email: 'ahmed@example.com',
        password: 'Password1!',
        step: 3,
        gender: Gender.male,
        age: 31,
        weight: 82,
        height: 180,
        goal: Goal.getFitter,
        activityLevel: ActivityLevel.intermediate,
      );

      expect(updated.firstName, 'Ahmed');
      expect(updated.lastName, 'Ali');
      expect(updated.email, 'ahmed@example.com');
      expect(updated.password, 'Password1!');
      expect(updated.step, 3);
      expect(updated.gender, Gender.male);
      expect(updated.age, 31);
      expect(updated.weight, 82);
      expect(updated.height, 180);
      expect(updated.goal, Goal.getFitter);
      expect(updated.activityLevel, ActivityLevel.intermediate);
    });

    test('keeps existing values when no arguments are provided', () {
      const original = RegisterFormData(
        firstName: 'Ahmed',
        step: 2,
        gender: Gender.female,
        goal: Goal.learnBasics,
      );

      final copy = original.copyWith();

      expect(copy, original);
      expect(copy, isNot(same(original)));
    });
  });

  test('RegisterFormData supports value equality', () {
    const first = RegisterFormData(firstName: 'Ahmed', step: 2);
    const second = RegisterFormData(firstName: 'Ahmed', step: 2);
    const different = RegisterFormData(firstName: 'Ali', step: 2);

    expect(first, second);
    expect(first.hashCode, second.hashCode);
    expect(first, isNot(different));
  });

  group('RegisterStateX.form', () {
    test('returns the state data when present', () {
      const form = RegisterFormData(firstName: 'Ahmed');
      const state = RegisterState(data: form);

      expect(state.form, same(form));
    });

    test('falls back to a default form when data is missing', () {
      const state = RegisterState();

      expect(state.form, const RegisterFormData());
    });
  });
}
