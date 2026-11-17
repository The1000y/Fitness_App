import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/meals/data/model/details_meal_dto.dart';
import 'package:fitness_app/features/meals/data/model/responses/meals_by_category_response/meals_by_category_response.dart';
import 'package:fitness_app/features/meals/data/model/responses/meals_categories_response/meals_categories_response.dart';

abstract interface class MealsRemoteDataSource {
  Future<MealsCategoriesResponse> getMealsCategories();

  Future<MealsByCategoryResponse> getMealsByCategory(String category);

  Future<BaseResponse<List<DetailsMealDto>>> getMealDetails(String mealId);
}
