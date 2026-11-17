import 'package:json_annotation/json_annotation.dart';

part 'meal_dto.g.dart';

@JsonSerializable()
class MealDTO {
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

  MealDTO({
    this.idMeal,
    this.strMeal,
    this.strMealThumb,
    this.strArea,
    this.strCountry,
  });

  factory MealDTO.fromJson(Map<String, dynamic> json) =>
      _$MealDTOFromJson(json);

  Map<String, dynamic> toJson() => _$MealDTOToJson(this);
}
