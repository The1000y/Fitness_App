import 'package:fitness_app/features/auth/domain/entities/onboarding/onboarding_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OnboardingEntity', () {
    test('props equality and field assignments work correctly', () {
      const entity1 = OnboardingEntity(
        id: '1',
        image: 'assets/images/onboarding1.png',
        title: 'Track your progress',
        description: 'Keep track of all your workout stats easily.',
      );

      const entity2 = OnboardingEntity(
        id: '1',
        image: 'assets/images/onboarding1.png',
        title: 'Track your progress',
        description: 'Keep track of all your workout stats easily.',
      );

      const entity3 = OnboardingEntity(
        id: '2',
        image: 'assets/images/onboarding2.png',
        title: 'Stay Healthy',
        description: 'Eat nutritious meals tailored to your needs.',
      );

      expect(entity1, equals(entity2));
      expect(entity1 == entity3, isFalse);
      expect(entity1.props, ['1', 'assets/images/onboarding1.png', 'Track your progress', 'Keep track of all your workout stats easily.']);
    });
  });
}

