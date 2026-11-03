import 'package:fitness_app/features/meals/data/model/responses/meals_by_category_response/meals_by_category_response.dart';
import 'package:fitness_app/features/meals/data/model/responses/meals_categories_response/meals_categories_response.dart';

abstract interface class MealsRemoteDataSource {
  Future<MealsCategoriesResponse> getMealsCategories();

  Future<MealsByCategoryResponse> getMealsByCategory(String category);
}
