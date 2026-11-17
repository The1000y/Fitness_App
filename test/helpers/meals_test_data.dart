import 'package:fitness_app/features/meals/data/model/responses/mapper/category_response_mapper.dart';
import 'package:fitness_app/features/meals/data/model/responses/mapper/meal_response_mapper.dart';
import 'package:fitness_app/features/meals/data/model/responses/meals_by_category_response/meals_by_category_response.dart';
import 'package:fitness_app/features/meals/data/model/responses/meals_categories_response/meals_categories_response.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_category_entity.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_entity.dart';

class MealsTestData {
  static const Map<String, dynamic> categoriesResponseJson = {
    'categories': [
      {
        'idCategory': '1',
        'strCategory': 'Beef',
        'strCategoryThumb':
            'https://www.themealdb.com/images/category/beef.png',
        'strCategoryDescription': 'Beef is meat from cattle.',
      },
      {
        'idCategory': '2',
        'strCategory': 'Chicken',
        'strCategoryThumb':
            'https://www.themealdb.com/images/category/chicken.png',
        'strCategoryDescription': 'Chicken is domestic fowl.',
      },
      {
        'idCategory': '3',
        'strCategory': 'Dessert',
        'strCategoryThumb':
            'https://www.themealdb.com/images/category/dessert.png',
        'strCategoryDescription': 'Sweet course at the end of a meal.',
      },
    ],
  };

  static const Map<String, dynamic> emptyCategoriesResponseJson = {
    'categories': <Map<String, dynamic>>[],
  };

  static const Map<String, dynamic> mealsResponseJson = {
    'meals': [
      {
        'strMeal': 'Beef Stew',
        'strMealThumb':
            'https://www.themealdb.com/images/media/meals/beef_stew.jpg',
        'idMeal': '52874',
        'strArea': 'British',
        'strCountry': 'United Kingdom',
      },
      {
        'strMeal': 'Beef and Oyster pie',
        'strMealThumb':
            'https://www.themealdb.com/images/media/meals/oyster_pie.jpg',
        'idMeal': '52878',
        'strArea': 'British',
        'strCountry': 'United Kingdom',
      },
    ],
  };

  static const Map<String, dynamic> chickenMealsResponseJson = {
    'meals': [
      {
        'strMeal': 'Chicken Curry',
        'strMealThumb':
            'https://www.themealdb.com/images/media/meals/chicken_curry.jpg',
        'idMeal': '52950',
        'strArea': 'Indian',
        'strCountry': 'India',
      },
    ],
  };

  static const Map<String, dynamic> emptyMealsResponseJson = {
    'meals': <Map<String, dynamic>>[],
  };

  static MealsCategoriesResponse get categoriesResponse =>
      MealsCategoriesResponse.fromJson(categoriesResponseJson);

  static MealsCategoriesResponse get emptyCategoriesResponse =>
      MealsCategoriesResponse.fromJson(emptyCategoriesResponseJson);

  static MealsByCategoryResponse get mealsResponse =>
      MealsByCategoryResponse.fromJson(mealsResponseJson);

  static MealsByCategoryResponse get chickenMealsResponse =>
      MealsByCategoryResponse.fromJson(chickenMealsResponseJson);

  static MealsByCategoryResponse get emptyMealsResponse =>
      MealsByCategoryResponse.fromJson(emptyMealsResponseJson);

  static List<MealCategoryEntity> get categoryEntities =>
      categoriesResponse.toEntity();

  static List<MealEntity> get mealEntities => mealsResponse.toEntity();

  static List<MealEntity> get chickenMealEntities =>
      chickenMealsResponse.toEntity();
}
