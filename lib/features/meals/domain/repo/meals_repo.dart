import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_category_entity.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_entity.dart';

abstract interface class MealsRepo {
  Future<BaseResponse<List<MealCategoryEntity>>> getMealsCategories();

  Future<BaseResponse<List<MealEntity>>> getMealsByCategory(String category);
}
