import 'dart:async';

import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/meals/api/client/meals_api_client.dart';
import 'package:fitness_app/features/meals/data/data_source/remote/meals_remote_data_source.dart';
import 'package:fitness_app/features/meals/data/model/responses/meals_by_category_response/meals_by_category_response.dart';
import 'package:fitness_app/features/meals/data/model/responses/meals_categories_response/meals_categories_response.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_category_entity.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_entity.dart';
import 'package:fitness_app/features/meals/domain/repo/meals_repo.dart';

import 'meals_test_data.dart';

class FakeMealsRepo implements MealsRepo {
  int getCategoriesCallCount = 0;
  int getMealsCallCount = 0;
  String? lastCategory;

  BaseResponse<List<MealCategoryEntity>>? nextCategoriesResult;
  BaseResponse<List<MealEntity>>? nextMealsResult;

  Completer<BaseResponse<List<MealCategoryEntity>>>? categoriesCompleter;
  Completer<BaseResponse<List<MealEntity>>>? mealsCompleter;

  @override
  Future<BaseResponse<List<MealCategoryEntity>>> getMealsCategories() async {
    getCategoriesCallCount++;
    if (categoriesCompleter != null) {
      return categoriesCompleter!.future;
    }
    return nextCategoriesResult ?? Success(MealsTestData.categoryEntities);
  }

  @override
  Future<BaseResponse<List<MealEntity>>> getMealsByCategory(
    String category,
  ) async {
    getMealsCallCount++;
    lastCategory = category;
    if (mealsCompleter != null) {
      return mealsCompleter!.future;
    }
    return nextMealsResult ?? Success(MealsTestData.mealEntities);
  }
}

class FakeMealsRemoteDataSource implements MealsRemoteDataSource {
  int getCategoriesCallCount = 0;
  int getMealsCallCount = 0;
  String? lastCategory;

  MealsCategoriesResponse? nextCategoriesResponse;
  MealsByCategoryResponse? nextMealsResponse;

  Object? nextCategoriesError;
  Object? nextMealsError;

  @override
  Future<MealsCategoriesResponse> getMealsCategories() async {
    getCategoriesCallCount++;
    if (nextCategoriesError != null) throw nextCategoriesError!;
    return nextCategoriesResponse ?? MealsTestData.categoriesResponse;
  }

  @override
  Future<MealsByCategoryResponse> getMealsByCategory(String category) async {
    getMealsCallCount++;
    lastCategory = category;
    if (nextMealsError != null) throw nextMealsError!;
    return nextMealsResponse ?? MealsTestData.mealsResponse;
  }
}

class FakeMealsApiClient implements MealsApiClient {
  int getCategoriesCallCount = 0;
  int getMealsCallCount = 0;
  String? lastCategory;

  MealsCategoriesResponse? nextCategoriesResponse;
  MealsByCategoryResponse? nextMealsResponse;
  Object? nextError;

  @override
  Future<MealsCategoriesResponse> getMealsCategories() async {
    getCategoriesCallCount++;
    if (nextError != null) throw nextError!;
    return nextCategoriesResponse ?? MealsTestData.categoriesResponse;
  }

  @override
  Future<MealsByCategoryResponse> getMealsByCategory(String category) async {
    getMealsCallCount++;
    lastCategory = category;
    if (nextError != null) throw nextError!;
    return nextMealsResponse ?? MealsTestData.mealsResponse;
  }
}
