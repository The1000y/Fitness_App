import 'package:fitness_app/features/meals/domain/entities/meal_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MealEntity', () {
    test('supports value equality via Equatable', () {
      const meal1 = MealEntity(
        id: '1',
        name: 'Chicken Breast',
        thumbnail: 'thumb.jpg',
        area: 'American',
        country: 'US',
        kcal: 165.0,
        proteinG: 31.0,
      );
      const meal2 = MealEntity(
        id: '1',
        name: 'Chicken Breast',
        thumbnail: 'thumb.jpg',
        area: 'American',
        country: 'US',
        kcal: 165.0,
        proteinG: 31.0,
      );

      expect(meal1, equals(meal2));
      expect(meal1.hashCode, equals(meal2.hashCode));
    });

    test('supports basic fields with null database fields', () {
      const meal = MealEntity(
        id: '52772',
        name: 'Teriyaki Chicken Casserole',
        thumbnail: 'https://example.com/thumb.jpg',
        area: 'Japanese',
        country: 'Japan',
      );

      expect(meal.id, '52772');
      expect(meal.name, 'Teriyaki Chicken Casserole');
      expect(meal.thumbnail, 'https://example.com/thumb.jpg');
      expect(meal.area, 'Japanese');
      expect(meal.country, 'Japan');
      expect(meal.kcal, isNull);
      expect(meal.proteinG, isNull);
      expect(meal.vegetarian, isNull);
    });

    test('supports extended database fields when provided', () {
      const meal = MealEntity(
        id: '52772',
        name: 'Teriyaki Chicken Casserole',
        thumbnail: 'https://example.com/thumb.jpg',
        area: 'Japanese',
        country: 'Japan',
        slug: 'teriyaki-chicken-casserole',
        nameAr: 'طاجن الدجاج الترياكي',
        category: 'Chicken',
        kcal: 395.0,
        proteinG: 34.0,
        carbsG: 25.0,
        fatG: 12.0,
        vegetarian: false,
        vegan: false,
        popularity: 90,
      );

      expect(meal.slug, 'teriyaki-chicken-casserole');
      expect(meal.nameAr, 'طاجن الدجاج الترياكي');
      expect(meal.category, 'Chicken');
      expect(meal.kcal, 395.0);
      expect(meal.proteinG, 34.0);
      expect(meal.carbsG, 25.0);
      expect(meal.fatG, 12.0);
      expect(meal.vegetarian, isFalse);
      expect(meal.vegan, isFalse);
      expect(meal.popularity, 90);
    });
  });
}
