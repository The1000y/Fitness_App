import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/meals/data/model/details_meal_dto.dart';

abstract interface class MealsRemoteDataSource {
  Future<BaseResponse<List<DetailsMealDto>>> getMealDetails(String mealId) ;
}