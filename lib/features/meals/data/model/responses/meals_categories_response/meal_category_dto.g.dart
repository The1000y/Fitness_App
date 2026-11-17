// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_category_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MealCategoryDTO _$MealCategoryDTOFromJson(Map<String, dynamic> json) =>
    MealCategoryDTO(
      idCategory: json['idCategory'] as String?,
      strCategory: json['strCategory'] as String?,
      strCategoryThumb: json['strCategoryThumb'] as String?,
      strCategoryDescription: json['strCategoryDescription'] as String?,
    );

Map<String, dynamic> _$MealCategoryDTOToJson(MealCategoryDTO instance) =>
    <String, dynamic>{
      'idCategory': instance.idCategory,
      'strCategory': instance.strCategory,
      'strCategoryThumb': instance.strCategoryThumb,
      'strCategoryDescription': instance.strCategoryDescription,
    };
