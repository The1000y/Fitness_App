import 'package:fitness_app/features/meals/data/model/responses/meals_by_category_response/meals_by_category_response.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_entity.dart';

extension MealResponseMapper on MealResponse {
  MealEntity toEntity() => MealEntity(
    id: idMeal ?? '',
    name: strMeal ?? '',
    thumbnail: strMealThumb ?? '',
    area: strArea,
    country: strCountry,
  );
}

extension MealsByCategoryResponseMapper on MealsByCategoryResponse {
  List<MealEntity> toEntity() =>
      meals?.map((e) => e.toEntity()).toList() ?? const [];
}
