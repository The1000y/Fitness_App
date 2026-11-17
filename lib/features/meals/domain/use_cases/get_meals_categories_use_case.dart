import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_category_entity.dart';
import 'package:fitness_app/features/meals/domain/repo/meals_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetMealsCategoriesUseCase {
  final MealsRepo _mealsRepo;
  GetMealsCategoriesUseCase(this._mealsRepo);

  Future<BaseResponse<List<MealCategoryEntity>>> call() async {
    return await _mealsRepo.getMealsCategories();
  }
}
