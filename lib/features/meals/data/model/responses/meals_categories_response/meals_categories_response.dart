import 'dart:convert';

import 'package:fitness_app/features/meals/data/model/responses/meals_categories_response/meal_category_response.dart';
import 'package:json_annotation/json_annotation.dart';

export 'meal_category_response.dart';

part 'meals_categories_response.g.dart';

MealsCategoriesResponse mealsCategoriesResponseFromJson(String str) =>
    MealsCategoriesResponse.fromJson(json.decode(str));

String mealsCategoriesResponseToJson(MealsCategoriesResponse data) =>
    json.encode(data.toJson());

@JsonSerializable(explicitToJson: true)
class MealsCategoriesResponse {
  @JsonKey(name: 'categories')
  final List<MealCategoryResponse>? categories;

  MealsCategoriesResponse({this.categories});

  factory MealsCategoriesResponse.fromJson(Map<String, dynamic> json) =>
      _$MealsCategoriesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MealsCategoriesResponseToJson(this);
}
