import 'dart:convert';
import 'package:fitness_app/features/meals/data/model/details_meal_dto.dart';
import 'package:fitness_app/features/meals/data/model/details_meal_response.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../helpers/test_data.dart';

void main() {
  group('DetailsMealDto and DetailsMealResponse', () {
    test('fromJson and toJson roundtrip preserves all fields', () {
      final dto = DetailsMealDto.fromJson(TestData.detailsMealDtoJson);

      expect(dto.idMeal, TestData.mealId);
      expect(dto.strMeal, TestData.mealName);
      expect(dto.strCategory, TestData.mealCategory);
      expect(dto.strArea, TestData.mealArea);
      expect(dto.strInstructions, TestData.mealInstructions);
      expect(dto.strMealThumb, TestData.mealThumb);
      expect(dto.strYoutube, TestData.mealYoutube);
      expect(dto.strTags, TestData.mealTags);
      expect(dto.strIngredient1, 'Salmon');
      expect(dto.strMeasure1, '2 fillets');

      final json = dto.toJson();
      expect(json['idMeal'], TestData.mealId);
      expect(json['strMeal'], TestData.mealName);
      expect(json['strCategory'], TestData.mealCategory);
      expect(json['strIngredient1'], 'Salmon');
      expect(json['strMeasure1'], '2 fillets');
    });

    test('detailsMealDtoFromJson and detailsMealDtoToJson helpers work', () {
      final jsonString = jsonEncode(TestData.detailsMealDtoJson);
      final dto = detailsMealDtoFromJson(jsonString);

      expect(dto.idMeal, TestData.mealId);

      final encoded = detailsMealDtoToJson(dto);
      final decoded = jsonDecode(encoded) as Map<String, dynamic>;
      expect(decoded['idMeal'], TestData.mealId);
      expect(decoded['strMeal'], TestData.mealName);
    });

    test('toEntity parses ingredients, trims whitespace, and skips empty ones', () {
      final dto = DetailsMealDto.fromJson({
        'idMeal': '123',
        'strMeal': 'Test Meal',
        'strCategory': 'Test Category',
        'strArea': 'Test Area',
        'strInstructions': 'Test Instructions',
        'strMealThumb': 'https://image.jpg',
        'strTags': 'Tag1,Tag2',
        'strYoutube': 'https://youtube.com',
        'strSource': 'https://source.com',
        'strIngredient1': '  Chicken Breast  ',
        'strMeasure1': '  200g  ',
        'strIngredient2': 'Olive Oil',
        'strMeasure2': '1 tbsp',
        'strIngredient3': '   ', // empty after trim -> should be skipped
        'strMeasure3': 'pinch',
        'strIngredient4': null, // null -> skipped
        'strMeasure4': null,
      });

      final entity = dto.toEntity();

      expect(entity.idMeal, '123');
      expect(entity.strMeal, 'Test Meal');
      expect(entity.ingredients.length, 2);
      expect(entity.ingredients[0].name, 'Chicken Breast');
      expect(entity.ingredients[0].measure, '200g');
      expect(entity.ingredients[1].name, 'Olive Oil');
      expect(entity.ingredients[1].measure, '1 tbsp');
    });

    test('toEntity defaults null fields to empty string for required properties', () {
      final dto = DetailsMealDto();
      final entity = dto.toEntity();

      expect(entity.idMeal, '');
      expect(entity.strMeal, '');
      expect(entity.strCategory, '');
      expect(entity.strArea, '');
      expect(entity.strInstructions, '');
      expect(entity.strMealThumb, '');
      expect(entity.strTags, '');
      expect(entity.strYoutube, '');
      expect(entity.strSource, '');
      expect(entity.strMealAlternate, isNull);
      expect(entity.strImageSource, isNull);
      expect(entity.strCreativeCommonsConfirmed, isNull);
      expect(entity.dateModified, isNull);
      expect(entity.ingredients, isEmpty);
    });

    test('DetailsMealResponse fromJson and toJson work correctly', () {
      final response = DetailsMealResponse.fromJson(TestData.detailsMealResponseJson);

      expect(response.meals, isNotNull);
      expect(response.meals!.length, 1);
      expect(response.meals!.first.idMeal, TestData.mealId);

      final json = response.toJson();
      expect(json['meals'], isA<List>());
      expect((json['meals'] as List).length, 1);
    });

    test('detailsMealResponseFromJson and detailsMealResponseToJson helpers work', () {
      final jsonString = jsonEncode(TestData.detailsMealResponseJson);
      final response = detailsMealResponseFromJson(jsonString);

      expect(response.meals, isNotNull);
      expect(response.meals!.first.idMeal, TestData.mealId);

      final encoded = detailsMealResponseToJson(response);
      final decoded = jsonDecode(encoded) as Map<String, dynamic>;
      expect(decoded['meals'], isA<List>());
    });

    test('DetailsMealResponse with null meals decodes and encodes properly', () {
      final response = DetailsMealResponse.fromJson({});
      expect(response.meals, isNull);

      final json = response.toJson();
      expect(json['meals'], isNull);
    });
  });
}

