import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_entity.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/manager/edit_profile_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/profile_fakes.dart';

void main() {
  group('EditProfileState', () {
    test('default constructor sets default values', () {
      const state = EditProfileState();

      expect(state.initialProfile, isNull);
      expect(state.weight, isNull);
      expect(state.goal, isNull);
      expect(state.activityLevel, isNull);
      expect(state.pickedPhotoPath, isNull);
      expect(state.saveState, const BaseState<ProfileEntity>());
      expect(state.isSaving, isFalse);
    });

    test('isSaving returns true when saveState.isLoading is true', () {
      const state = EditProfileState(
        saveState: BaseState<ProfileEntity>(isLoading: true),
      );

      expect(state.isSaving, isTrue);
    });

    test('isSaving returns false when saveState is not loading', () {
      const state = EditProfileState(
        saveState: BaseState<ProfileEntity>(
          errorMessage: ServerFailure(),
        ),
      );

      expect(state.isSaving, isFalse);
    });

    group('copyWith', () {
      test('without parameters retains all original values', () {
        const original = EditProfileState(
          initialProfile: testProfile,
          weight: 75.0,
          goal: 'gain',
          activityLevel: 'rookie',
          pickedPhotoPath: '/path/test.png',
          saveState: BaseState<ProfileEntity>(isLoading: true),
        );

        final copy = original.copyWith();

        expect(copy, equals(original));
        expect(copy.initialProfile, testProfile);
        expect(copy.weight, 75.0);
        expect(copy.goal, 'gain');
        expect(copy.activityLevel, 'rookie');
        expect(copy.pickedPhotoPath, '/path/test.png');
        expect(copy.saveState.isLoading, isTrue);
      });

      test('replaces each field when provided', () {
        const original = EditProfileState();

        final updated = original.copyWith(
          initialProfile: testProfile,
          weight: 80.0,
          goal: 'lose',
          activityLevel: 'beast',
          pickedPhotoPath: '/new/path.png',
          saveState: const BaseState<ProfileEntity>(data: testProfile),
        );

        expect(updated.initialProfile, testProfile);
        expect(updated.weight, 80.0);
        expect(updated.goal, 'lose');
        expect(updated.activityLevel, 'beast');
        expect(updated.pickedPhotoPath, '/new/path.png');
        expect(updated.saveState.data, testProfile);
      });

      test('allows setting nullable fields to null using null argument', () {
        const original = EditProfileState(
          initialProfile: testProfile,
          weight: 70.0,
          goal: 'gain',
          activityLevel: 'intermediate',
          pickedPhotoPath: '/some/path.png',
        );

        final updated = original.copyWith(
          initialProfile: null,
          weight: null,
          goal: null,
          activityLevel: null,
          pickedPhotoPath: null,
        );

        expect(updated.initialProfile, isNull);
        expect(updated.weight, isNull);
        expect(updated.goal, isNull);
        expect(updated.activityLevel, isNull);
        expect(updated.pickedPhotoPath, isNull);
      });
    });

    group('Equatable props', () {
      test('states with identical fields are equal', () {
        const a = EditProfileState(
          initialProfile: testProfile,
          weight: 65.0,
          goal: 'gain',
          activityLevel: 'beginner',
          pickedPhotoPath: '/path.png',
        );
        const b = EditProfileState(
          initialProfile: testProfile,
          weight: 65.0,
          goal: 'gain',
          activityLevel: 'beginner',
          pickedPhotoPath: '/path.png',
        );

        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('states with different fields are not equal', () {
        const a = EditProfileState(weight: 65.0);
        const b = EditProfileState(weight: 70.0);

        expect(a, isNot(equals(b)));
      });

      test('props contains all relevant state fields', () {
        const state = EditProfileState(
          initialProfile: testProfile,
          weight: 65.0,
          goal: 'gain',
          activityLevel: 'beginner',
          pickedPhotoPath: '/path.png',
        );

        expect(state.props, [
          testProfile,
          65.0,
          'gain',
          'beginner',
          '/path.png',
          const BaseState<ProfileEntity>(),
        ]);
      });
    });
  });
}
