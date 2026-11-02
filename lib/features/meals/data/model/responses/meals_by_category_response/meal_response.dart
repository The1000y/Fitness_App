import 'package:json_annotation/json_annotation.dart';

part 'meal_response.g.dart';

@JsonSerializable()
class MealResponse {
  @JsonKey(name: 'idMeal')
  final String? idMeal;

  @JsonKey(name: 'strMeal')
  final String? strMeal;

  @JsonKey(name: 'strMealThumb')
  final String? strMealThumb;

  @JsonKey(name: 'strArea')
  final String? strArea;

  @JsonKey(name: 'strCountry')
  final String? strCountry;

  MealResponse({
    this.idMeal,
    this.strMeal,
    this.strMealThumb,
    this.strArea,
    this.strCountry,
  });

  factory MealResponse.fromJson(Map<String, dynamic> json) =>
      _$MealResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MealResponseToJson(this);
}
