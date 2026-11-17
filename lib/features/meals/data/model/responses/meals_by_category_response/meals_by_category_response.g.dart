// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meals_by_category_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MealsByCategoryResponse _$MealsByCategoryResponseFromJson(
  Map<String, dynamic> json,
) => MealsByCategoryResponse(
  meals: (json['meals'] as List<dynamic>?)
      ?.map((e) => MealDTO.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MealsByCategoryResponseToJson(
  MealsByCategoryResponse instance,
) => <String, dynamic>{
  'meals': instance.meals?.map((e) => e.toJson()).toList(),
};
