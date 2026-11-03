import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/meals/domain/entities/details_meal_entity.dart';
import 'package:fitness_app/features/meals/domain/repo/meals_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetMealDetailsUseCase {
  final MealsRepo mealsRepo;
  GetMealDetailsUseCase(this.mealsRepo);
  Future<BaseResponse<List<DetailsMealEntity>>> call(String mealId) async {
    final resultListMeals = await mealsRepo.getMealDetails(mealId);
    return resultListMeals;
  }
}
