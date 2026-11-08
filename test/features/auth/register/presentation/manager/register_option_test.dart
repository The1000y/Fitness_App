import 'package:fitness_app/features/auth/presentation/register/manager/register_option.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GenderApi', () {
    test('maps genders to their API values', () {
      expect(Gender.male.apiValue, 'male');
      expect(Gender.female.apiValue, 'female');
    });
  });

  group('GoalApi', () {
    test('maps every goal to its API value', () {
      expect(Goal.gainWeight.apiValue, 'Gain weight');
      expect(Goal.loseWeight.apiValue, 'Lose weight');
      expect(Goal.getFitter.apiValue, 'Get fitter');
      expect(Goal.gainFlexibility.apiValue, 'Gain more flexible');
      expect(Goal.learnBasics.apiValue, 'Learn the basics');
    });
  });

  group('ActivityLevelApi', () {
    test('maps every activity level to its API value', () {
      expect(ActivityLevel.rookie.apiValue, 'level1');
      expect(ActivityLevel.beginner.apiValue, 'level2');
      expect(ActivityLevel.intermediate.apiValue, 'level3');
      expect(ActivityLevel.advance.apiValue, 'level4');
      expect(ActivityLevel.trueBeast.apiValue, 'level5');
    });
  });
}
