import 'package:fitness_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProfileEntity', () {
    test('fullName joins first and last name', () {
      const profile = ProfileEntity(
        id: '1',
        firstName: 'Ada',
        lastName: 'Lovelace',
        email: 'ada@example.com',
        gender: 'female',
        age: 30,
        weight: 60,
        height: 170,
        activityLevel: 'active',
        goal: 'fitness',
        photo: '',
      );

      expect(profile.fullName, 'Ada Lovelace');
    });

    test('fullName trims empty name parts', () {
      const onlyFirstName = ProfileEntity(
        id: '1',
        firstName: 'Ada',
        lastName: '',
        email: '',
        gender: '',
        age: 0,
        weight: 0,
        height: 0,
        activityLevel: '',
        goal: '',
        photo: '',
      );

      expect(onlyFirstName.fullName, 'Ada');
      expect(ProfileEntity.empty.fullName, '');
    });

    test('equal values are equal', () {
      const first = ProfileEntity(
        id: '1',
        firstName: 'Ada',
        lastName: 'Lovelace',
        email: 'ada@example.com',
        gender: 'female',
        age: 30,
        weight: 60,
        height: 170,
        activityLevel: 'active',
        goal: 'fitness',
        photo: 'avatar.png',
      );
      const second = ProfileEntity(
        id: '1',
        firstName: 'Ada',
        lastName: 'Lovelace',
        email: 'ada@example.com',
        gender: 'female',
        age: 30,
        weight: 60,
        height: 170,
        activityLevel: 'active',
        goal: 'fitness',
        photo: 'avatar.png',
      );

      expect(first, second);
      expect(first.hashCode, second.hashCode);
    });

    test('different values are not equal', () {
      expect(
        ProfileEntity.empty,
        isNot(
          const ProfileEntity(
            id: '1',
            firstName: 'Ada',
            lastName: 'Lovelace',
            email: '',
            gender: '',
            age: 0,
            weight: 0,
            height: 0,
            activityLevel: '',
            goal: '',
            photo: '',
          ),
        ),
      );
    });
  });
}
