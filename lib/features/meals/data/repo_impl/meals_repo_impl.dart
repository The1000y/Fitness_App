import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/utils/excecute_api_call.dart';
import 'package:fitness_app/features/meals/data/data_source/remote/meals_remote_data_source.dart';
import 'package:fitness_app/features/meals/data/model/responses/mapper/category_response_mapper.dart';
import 'package:fitness_app/features/meals/data/model/responses/mapper/meal_response_mapper.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_category_entity.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_entity.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repo/meals_repo.dart';

@Injectable(as: MealsRepo)
class MealsRepoImpl implements MealsRepo {
  final MealsRemoteDataSource _mealsRemoteDataSource;

  MealsRepoImpl(this._mealsRemoteDataSource);

  @override
  Future<BaseResponse<List<MealCategoryEntity>>> getMealsCategories() async {
    final result = await excecuteApiCall(
      () =>
          _mealsRemoteDataSource.getMealsCategories().then((r) => r.toEntity()),
    );

    return result;
  }

  @override
  Future<BaseResponse<List<MealEntity>>> getMealsByCategory(
    String category,
  ) async {
    final result = await excecuteApiCall(
      () => _mealsRemoteDataSource
          .getMealsByCategory(category)
          .then((r) => r.toEntity()),
    );

    return result;
  }
}
