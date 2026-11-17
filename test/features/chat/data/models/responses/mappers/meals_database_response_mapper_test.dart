import 'package:fitness_app/features/chat/data/models/responses/mappers/meals_database_response_mapper.dart';
import 'package:fitness_app/features/chat/data/models/responses/meals_database_response/meal_database_dto.dart';
import 'package:fitness_app/features/chat/data/models/responses/meals_database_response/meals_database_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MealDatabaseDtoMapper', () {
    test(
      'maps MealDatabaseDTO to MealEntity correctly with extended database fields',
      () {
        const dto = MealDatabaseDTO(
          id: '52772',
          slug: 'teriyaki-chicken-casserole',
          name: 'Teriyaki Chicken Casserole',
          nameAr: 'طاجن الدجاج الترياكي',
          categoryId: 'Chicken',
          areaId: 'Japanese',
          mealType: 'Dinner',
          instructions: 'Mix and bake',
          kcal: 395.0,
          proteinG: 34.0,
          carbsG: 25.0,
          fatG: 12.0,
          servingsAssumed: 4,
          nutritionConfidence: 0.95,
          nutritionIsEstimate: 1,
          vegetarian: 0,
          vegan: 0,
          pescatarian: 0,
          containsGluten: 1,
          containsDairyOrEgg: 0,
          containsNuts: 0,
          ingredientCount: 8,
          thumb: 'https://example.com/thumb.jpg',
          youtube: 'https://youtube.com/watch?v=123',
          source: 'https://example.com/recipe',
          dateModified: '2021-01-01',
          popularity: 90,
        );

        final entity = dto.toEntity();

        expect(entity.id, '52772');
        expect(entity.name, 'Teriyaki Chicken Casserole');
        expect(entity.thumbnail, 'https://example.com/thumb.jpg');
        expect(entity.area, 'Japanese');
        expect(entity.country, isNull);
        expect(entity.slug, 'teriyaki-chicken-casserole');
        expect(entity.nameAr, 'طاجن الدجاج الترياكي');
        expect(entity.category, 'Chicken');
        expect(entity.mealType, 'Dinner');
        expect(entity.instructions, 'Mix and bake');
        expect(entity.kcal, 395.0);
        expect(entity.proteinG, 34.0);
        expect(entity.carbsG, 25.0);
        expect(entity.fatG, 12.0);
        expect(entity.servingsAssumed, 4);
        expect(entity.nutritionConfidence, 0.95);
        expect(entity.nutritionIsEstimate, isTrue);
        expect(entity.vegetarian, isFalse);
        expect(entity.vegan, isFalse);
        expect(entity.containsGluten, isTrue);
        expect(entity.youtube, 'https://youtube.com/watch?v=123');
        expect(entity.source, 'https://example.com/recipe');
        expect(entity.popularity, 90);
        expect(entity.dateModified, '2021-01-01');
      },
    );

    test('falls back to imageLarge/Medium/Small if thumb is null', () {
      const dto = MealDatabaseDTO(
        id: '1',
        name: 'Test',
        imageLarge: 'https://example.com/large.jpg',
      );

      final entity = dto.toEntity();
      expect(entity.thumbnail, 'https://example.com/large.jpg');
    });

    test(
      'maps MealDatabaseDTO to DetailsMealEntity correctly with nutrition fields',
      () {
        const dto = MealDatabaseDTO(
          id: '52772',
          name: 'Teriyaki Chicken Casserole',
          nameAr: 'طاجن الدجاج الترياكي',
          categoryId: 'Chicken',
          areaId: 'Japanese',
          instructions: 'Mix and bake',
          thumb: 'https://example.com/thumb.jpg',
          mealType: 'Dinner',
          youtube: 'https://youtube.com/watch?v=123',
          source: 'https://example.com/recipe',
          dateModified: '2021-01-01',
          kcal: 395.0,
          proteinG: 34.0,
          carbsG: 25.0,
          fatG: 12.0,
          vegetarian: 0,
          vegan: 0,
          popularity: 95,
        );

        final details = dto.toDetailsEntity();

        expect(details.idMeal, '52772');
        expect(details.strMeal, 'Teriyaki Chicken Casserole');
        expect(details.strMealAlternate, 'طاجن الدجاج الترياكي');
        expect(details.strCategory, 'Chicken');
        expect(details.strArea, 'Japanese');
        expect(details.strInstructions, 'Mix and bake');
        expect(details.strMealThumb, 'https://example.com/thumb.jpg');
        expect(details.strTags, 'Dinner');
        expect(details.strYoutube, 'https://youtube.com/watch?v=123');
        expect(details.strSource, 'https://example.com/recipe');
        expect(details.dateModified, '2021-01-01');
        expect(details.ingredients, isEmpty);
        expect(details.kcal, 395.0);
        expect(details.proteinG, 34.0);
        expect(details.carbsG, 25.0);
        expect(details.fatG, 12.0);
        expect(details.vegetarian, isFalse);
        expect(details.vegan, isFalse);
        expect(details.popularity, 95);
      },
    );
  });

  group('MealsDatabaseResponseMapper', () {
    test('maps MealsDatabaseResponse to List<MealEntity>', () {
      final response = MealsDatabaseResponse(
        meals: const [
          MealDatabaseDTO(id: '1', name: 'Meal 1', thumb: 'thumb1.jpg'),
          MealDatabaseDTO(id: '2', name: 'Meal 2', thumb: 'thumb2.jpg'),
        ],
      );

      final entities = response.toEntity();

      expect(entities.length, 2);
      expect(entities[0].id, '1');
      expect(entities[1].id, '2');
    });

    test('returns empty list if response.meals is null', () {
      final response = MealsDatabaseResponse(meals: null);
      expect(response.toEntity(), isEmpty);
      expect(response.toDetailsEntities(), isEmpty);
    });
  });
}
