import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_entity.dart';
import 'package:fitness_app/features/meals/domain/repo/meals_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetMealsByCategoryUseCase {
  final MealsRepo _mealsRepo;
  GetMealsByCategoryUseCase(this._mealsRepo);

  Future<BaseResponse<List<MealEntity>>> call(String category) async {
    return await _mealsRepo.getMealsByCategory(category);
  }
}
