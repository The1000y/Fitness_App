import 'package:dio/dio.dart';
import 'package:fitness_app/core/constants/api_strings.dart';
import 'package:fitness_app/features/meals/data/model/responses/meals_by_category_response/meals_by_category_response.dart';
import 'package:fitness_app/features/meals/data/model/responses/meals_categories_response/meals_categories_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'meals_api_client.g.dart';

@singleton
@RestApi()
abstract class MealsApiClient {
  @factoryMethod
  factory MealsApiClient(@Named(ApiStrings.namedMealDio) Dio dio) =
      _MealsApiClient;

  @GET(ApiStrings.mealCategories)
  Future<MealsCategoriesResponse> getMealsCategories();

  @GET(ApiStrings.mealsByCategory)
  Future<MealsByCategoryResponse> getMealsByCategory(
    @Query('c') String category,
  );
}
