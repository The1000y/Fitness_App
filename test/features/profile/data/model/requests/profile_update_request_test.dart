import 'package:fitness_app/features/profile/data/model/requests/profile_update_request.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProfileUpdateRequest', () {
    test('toJson_usesLowercaseApiKeys', () {
      const request = ProfileUpdateRequest(
        firstName: 'John',
        lastName: 'Doe',
        gender: 'male',
        age: 25,
        weight: 80.0,
        height: 180.0,
        activityLevel: 'rookie',
        goal: 'gain',
      );

      final json = request.toJson();

      expect(json, {
        'firstName': 'John',
        'lastName': 'Doe',
        'gender': 'male',
        'age': 25,
        'weight': 80.0,
        'height': 180.0,
        'activityLevel': 'rookie',
        'goal': 'gain',
      });
    });

    test('toJson_omitsNullFields', () {
      const request = ProfileUpdateRequest(
        lastName: 'Tech2',
      );

      final json = request.toJson();

      expect(json, {'lastName': 'Tech2'});
      expect(json.containsKey('firstName'), isFalse);
      expect(json.containsKey('gender'), isFalse);
      expect(json.containsKey('age'), isFalse);
      expect(json.containsKey('weight'), isFalse);
      expect(json.containsKey('height'), isFalse);
      expect(json.containsKey('activityLevel'), isFalse);
      expect(json.containsKey('goal'), isFalse);
    });

    test('fromJson_restoresAllFields', () {
      final json = {
        'firstName': 'John',
        'lastName': 'Doe',
        'gender': 'male',
        'age': 25,
        'weight': 80.0,
        'height': 180.0,
        'activityLevel': 'rookie',
        'goal': 'gain',
      };

      final request = ProfileUpdateRequest.fromJson(json);

      expect(request.firstName, 'John');
      expect(request.lastName, 'Doe');
      expect(request.gender, 'male');
      expect(request.age, 25);
      expect(request.weight, 80.0);
      expect(request.height, 180.0);
      expect(request.activityLevel, 'rookie');
      expect(request.goal, 'gain');
    });
  });
}
