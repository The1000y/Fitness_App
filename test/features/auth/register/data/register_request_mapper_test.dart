import 'package:fitness_app/features/auth/data/model/requests/register_request/register_request_mapper.dart';
import 'package:fitness_app/features/auth/domain/entities/params/register_params_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RegisterParamsMapper.toDto', () {
    test('maps every field to the request DTO', () {
      final params = RegisterParams(
        firstName: 'Ahmed',
        lastName: 'Ali',
        email: 'ahmed@example.com',
        password: 'Password1!',
        rePassword: 'Password1!',
        gender: 'male',
        height: 180,
        weight: 82,
        age: 31,
        goal: 'Lose weight',
        activityLevel: 'level3',
      );

      final dto = params.toDto();

      expect(dto.firstName, 'Ahmed');
      expect(dto.lastName, 'Ali');
      expect(dto.email, 'ahmed@example.com');
      expect(dto.password, 'Password1!');
      expect(dto.rePassword, 'Password1!');
      expect(dto.gender, 'male');
      expect(dto.height, 180);
      expect(dto.weight, 82);
      expect(dto.age, 31);
      expect(dto.goal, 'Lose weight');
      expect(dto.activityLevel, 'level3');
    });

    test('serializes the mapped fields to JSON', () {
      final dto = RegisterParams(
        firstName: 'Ahmed',
        lastName: 'Ali',
        email: 'ahmed@example.com',
        password: 'Password1!',
        rePassword: 'Password1!',
        gender: 'male',
        height: 180,
        weight: 82,
        age: 31,
        goal: 'Lose weight',
        activityLevel: 'level3',
      ).toDto();

      expect(dto.toJson(), {
        'firstName': 'Ahmed',
        'lastName': 'Ali',
        'email': 'ahmed@example.com',
        'password': 'Password1!',
        'rePassword': 'Password1!',
        'gender': 'male',
        'height': 180,
        'weight': 82,
        'age': 31,
        'goal': 'Lose weight',
        'activityLevel': 'level3',
      });
    });
  });
}
