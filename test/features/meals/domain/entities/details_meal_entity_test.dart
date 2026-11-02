import 'package:fitness_app/features/meals/domain/entities/details_meal_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('IngredientEntity', () {
    test('props equality works correctly', () {
      const ingredient1 = IngredientEntity(
        name: 'Salmon',
        measure: '2 fillets',
      );
      const ingredient2 = IngredientEntity(
        name: 'Salmon',
        measure: '2 fillets',
      );
      const ingredient3 = IngredientEntity(name: 'Fennel', measure: '1 bulb');

      expect(ingredient1, equals(ingredient2));
      expect(ingredient1 == ingredient3, isFalse);
      expect(ingredient1.props, equals(['Salmon', '2 fillets']));
    });
  });

  group('DetailsMealEntity', () {
    test('props equality and field assignments work correctly', () {
      const entity1 = DetailsMealEntity(
        idMeal: '52959',
        strMeal: 'Baked salmon',
        strMealAlternate: null,
        strCategory: 'Seafood',
        strArea: 'British',
        strInstructions: 'Cook it',
        strMealThumb: 'thumb.jpg',
        strTags: 'Fish',
        strYoutube: 'https://youtube.com',
        strSource: 'https://source.com',
        strImageSource: null,
        strCreativeCommonsConfirmed: null,
        dateModified: null,
        ingredients: [IngredientEntity(name: 'Salmon', measure: '2 fillets')],
      );

      const entity2 = DetailsMealEntity(
        idMeal: '52959',
        strMeal: 'Baked salmon',
        strMealAlternate: null,
        strCategory: 'Seafood',
        strArea: 'British',
        strInstructions: 'Cook it',
        strMealThumb: 'thumb.jpg',
        strTags: 'Fish',
        strYoutube: 'https://youtube.com',
        strSource: 'https://source.com',
        strImageSource: null,
        strCreativeCommonsConfirmed: null,
        dateModified: null,
        ingredients: [IngredientEntity(name: 'Salmon', measure: '2 fillets')],
      );

      const entity3 = DetailsMealEntity(
        idMeal: '52960',
        strMeal: 'Other meal',
        strCategory: 'Meat',
        strArea: 'American',
        strInstructions: 'Bake it',
        strMealThumb: 'other.jpg',
        strTags: 'Meat',
        strYoutube: '',
        strSource: '',
        ingredients: [],
      );

      expect(entity1, equals(entity2));
      expect(entity1 == entity3, isFalse);
      expect(entity1.props.length, 14);
      expect(entity1.idMeal, '52959');
      expect(entity1.strMeal, 'Baked salmon');
      expect(entity1.strCategory, 'Seafood');
      expect(entity1.ingredients.length, 1);
    });
  });
}
