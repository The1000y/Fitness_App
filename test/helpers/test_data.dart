import 'package:fitness_app/features/auth/data/model/responses/login_response/login_response.dart';
import 'package:fitness_app/features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:fitness_app/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:fitness_app/features/meals/data/model/details_meal_dto.dart';
import 'package:fitness_app/features/meals/data/model/details_meal_response.dart';
import 'package:fitness_app/features/meals/domain/entities/details_meal_entity.dart';

class TestData {
  static const String validEmail = 'test@example.com';
  static const String validPassword = 'Test@1234';
  static const String fakeToken = 'fake.jwt.token';

  static const Map<String, dynamic> loginResponseJson = {
    'message': 'Login successful',
    'token': fakeToken,
    'user': {
      '_id': 'user_123',
      'firstName': 'John',
      'lastName': 'Doe',
      'email': validEmail,
      'gender': 'male',
      'age': 25,
      'weight': 70,
      'height': 175,
      'activityLevel': 'active',
      'goal': 'fitness',
      'photo': 'photo.png',
      'createdAt': '2026-01-01T00:00:00.000Z',
    },
  };

  static LoginResponse get loginResponse =>
      LoginResponse.fromJson(loginResponseJson);
  static LoginEntity get loginEntity => loginResponse.toEntity();
  static UserEntity get userEntity => loginEntity.user;

  // Meal test data
  static const String mealId = '52959';
  static const String mealName = 'Baked salmon with fennel & tomatoes';
  static const String mealCategory = 'Seafood';
  static const String mealArea = 'British';
  static const String mealInstructions = 'Heat oven to 180C/160C fan/gas 4...';
  static const String mealThumb =
      'https://www.themealdb.com/images/media/meals/1548772327.jpg';
  static const String mealYoutube =
      'https://www.youtube.com/watch?v=4aZr5hZXP_s';
  static const String mealTags = 'Fish,Keto';
  static const String mealSource =
      'https://www.bbcgoodfood.com/recipes/baked-salmon-fennel-tomatoes';

  static const Map<String, dynamic> detailsMealDtoJson = {
    'idMeal': mealId,
    'strMeal': mealName,
    'strMealAlternate': null,
    'strCategory': mealCategory,
    'strArea': mealArea,
    'strCountry': null,
    'strInstructions': mealInstructions,
    'strMealThumb': mealThumb,
    'strTags': mealTags,
    'strYoutube': mealYoutube,
    'strIngredient1': 'Salmon',
    'strIngredient2': 'Fennel',
    'strIngredient3': 'Cherry Tomatoes',
    'strIngredient4': '',
    'strIngredient5': null,
    'strIngredient6': null,
    'strIngredient7': null,
    'strIngredient8': null,
    'strIngredient9': null,
    'strIngredient10': null,
    'strIngredient11': null,
    'strIngredient12': null,
    'strIngredient13': null,
    'strIngredient14': null,
    'strIngredient15': null,
    'strIngredient16': null,
    'strIngredient17': null,
    'strIngredient18': null,
    'strIngredient19': null,
    'strIngredient20': null,
    'strMeasure1': '2 fillets',
    'strMeasure2': '1 bulb',
    'strMeasure3': '150g',
    'strMeasure4': '',
    'strMeasure5': null,
    'strMeasure6': null,
    'strMeasure7': null,
    'strMeasure8': null,
    'strMeasure9': null,
    'strMeasure10': null,
    'strMeasure11': null,
    'strMeasure12': null,
    'strMeasure13': null,
    'strMeasure14': null,
    'strMeasure15': null,
    'strMeasure16': null,
    'strMeasure17': null,
    'strMeasure18': null,
    'strMeasure19': null,
    'strMeasure20': null,
    'strSource': mealSource,
    'strImageSource': null,
    'strCreativeCommonsConfirmed': null,
    'dateModified': null,
  };

  static const Map<String, dynamic> detailsMealResponseJson = {
    'meals': [detailsMealDtoJson],
  };

  static DetailsMealDto get detailsMealDto =>
      DetailsMealDto.fromJson(detailsMealDtoJson);
  static DetailsMealResponse get detailsMealResponse =>
      DetailsMealResponse.fromJson(detailsMealResponseJson);
  static DetailsMealEntity get detailsMealEntity => detailsMealDto.toEntity();
  static List<IngredientEntity> get sampleIngredients => [
    const IngredientEntity(name: 'Salmon', measure: '2 fillets'),
    const IngredientEntity(name: 'Fennel', measure: '1 bulb'),
    const IngredientEntity(name: 'Cherry Tomatoes', measure: '150g'),
  ];
}
