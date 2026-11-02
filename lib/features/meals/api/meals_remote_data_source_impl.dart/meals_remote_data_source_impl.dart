import 'package:fitness_app/features/meals/api/client/meals_api_client.dart';
import 'package:fitness_app/features/meals/data/model/responses/meals_by_category_response/meals_by_category_response.dart';
import 'package:fitness_app/features/meals/data/model/responses/meals_categories_response/meals_categories_response.dart';
import 'package:injectable/injectable.dart';

import '../../data/data_source/remote/meals_remote_data_source.dart';

@Injectable(as: MealsRemoteDataSource)
class MealsRemoteDataSourceImpl implements MealsRemoteDataSource {
  final MealsApiClient _mealsApiClient;
  MealsRemoteDataSourceImpl(this._mealsApiClient);

  @override
  Future<MealsCategoriesResponse> getMealsCategories() async {
    return await _mealsApiClient.getMealsCategories();
  }

  @override
  Future<MealsByCategoryResponse> getMealsByCategory(String category) async {
    return await _mealsApiClient.getMealsByCategory(category);
  }
}
