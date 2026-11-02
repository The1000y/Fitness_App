import 'package:fitness_app/features/meals/data/model/responses/meals_categories_response/meals_categories_response.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_category_entity.dart';

extension CategoryResponseMapper on MealCategoryResponse {
  MealCategoryEntity toEntity() => MealCategoryEntity(
    id: idCategory ?? '',
    name: strCategory ?? '',
    thumbnail: strCategoryThumb ?? '',
    description: strCategoryDescription ?? '',
  );
}

extension MealsCategoriesResponseMapper on MealsCategoriesResponse {
  List<MealCategoryEntity> toEntity() =>
      categories?.map((e) => e.toEntity()).toList() ?? const [];
}
