// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'details_meal_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailsMealResponse _$DetailsMealResponseFromJson(Map<String, dynamic> json) =>
    DetailsMealResponse(
      meals: (json['meals'] as List<dynamic>?)
          ?.map((e) => DetailsMealDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DetailsMealResponseToJson(
  DetailsMealResponse instance,
) => <String, dynamic>{'meals': instance.meals};
