import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/meals/domain/entities/details_meal_entity.dart';

abstract interface class MealsRepo {
  Future<BaseResponse<List<DetailsMealEntity>>> getMealDetails(String mealId);
}