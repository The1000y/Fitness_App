import 'package:json_annotation/json_annotation.dart';

part 'meal_category_dto.g.dart';

@JsonSerializable()
class MealCategoryDTO {
  @JsonKey(name: 'idCategory')
  final String? idCategory;

  @JsonKey(name: 'strCategory')
  final String? strCategory;

  @JsonKey(name: 'strCategoryThumb')
  final String? strCategoryThumb;

  @JsonKey(name: 'strCategoryDescription')
  final String? strCategoryDescription;

  MealCategoryDTO({
    this.idCategory,
    this.strCategory,
    this.strCategoryThumb,
    this.strCategoryDescription,
  });

  factory MealCategoryDTO.fromJson(Map<String, dynamic> json) =>
      _$MealCategoryDTOFromJson(json);

  Map<String, dynamic> toJson() => _$MealCategoryDTOToJson(this);
}
