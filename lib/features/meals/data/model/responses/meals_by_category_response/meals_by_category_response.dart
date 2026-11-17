import 'dart:convert';

import 'package:fitness_app/features/meals/data/model/responses/meals_by_category_response/meal_dto.dart';
import 'package:json_annotation/json_annotation.dart';

export 'meal_dto.dart';

part 'meals_by_category_response.g.dart';

MealsByCategoryResponse mealsByCategoryResponseFromJson(String str) =>
    MealsByCategoryResponse.fromJson(json.decode(str));

String mealsByCategoryResponseToJson(MealsByCategoryResponse data) =>
    json.encode(data.toJson());

@JsonSerializable(explicitToJson: true)
class MealsByCategoryResponse {
  @JsonKey(name: 'meals')
  final List<MealDTO>? meals;

  MealsByCategoryResponse({this.meals});

  factory MealsByCategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$MealsByCategoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MealsByCategoryResponseToJson(this);
}

typedef MealsResponse = MealsByCategoryResponse;
