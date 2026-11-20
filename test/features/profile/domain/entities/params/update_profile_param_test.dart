import 'package:fitness_app/features/profile/domain/entities/params/update_profile_param.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UpdateProfileParam', () {
    test('equal values have value equality and same hashCode', () {
      const a = UpdateProfileParam(
        firstName: 'Ada',
        lastName: 'Lovelace',
        gender: 'female',
        age: 30,
        weight: 60.5,
        height: 170.0,
        activityLevel: 'active',
        goal: 'fitness',
      );
      const b = UpdateProfileParam(
        firstName: 'Ada',
        lastName: 'Lovelace',
        gender: 'female',
        age: 30,
        weight: 60.5,
        height: 170.0,
        activityLevel: 'active',
        goal: 'fitness',
      );

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('different values are not equal', () {
      const a = UpdateProfileParam(firstName: 'Ada');
      const b = UpdateProfileParam(firstName: 'Grace');

      expect(a, isNot(equals(b)));
    });

    test('default empty instance has all null fields', () {
      const param = UpdateProfileParam();

      expect(param.firstName, isNull);
      expect(param.lastName, isNull);
      expect(param.gender, isNull);
      expect(param.age, isNull);
      expect(param.weight, isNull);
      expect(param.height, isNull);
      expect(param.activityLevel, isNull);
      expect(param.goal, isNull);
    });

    test('props contains all fields in expected order', () {
      const param = UpdateProfileParam(
        firstName: 'Ada',
        lastName: 'Lovelace',
        gender: 'female',
        age: 30,
        weight: 60.5,
        height: 170.0,
        activityLevel: 'active',
        goal: 'fitness',
      );

      expect(param.props, [
        'Ada',
        'Lovelace',
        'female',
        30,
        60.5,
        170.0,
        'active',
        'fitness',
      ]);
    });
  });
}
