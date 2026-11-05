// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'difficulty_levels_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DifficultyLevelsResponse _$DifficultyLevelsResponseFromJson(
  Map<String, dynamic> json,
) => DifficultyLevelsResponse(
  message: json['message'] as String?,
  totalLevels: (json['totalLevels'] as num?)?.toInt(),
  difficultyLevels: (json['difficulty_levels'] as List<dynamic>?)
      ?.map((e) => DifficultyLevelResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DifficultyLevelsResponseToJson(
  DifficultyLevelsResponse instance,
) => <String, dynamic>{
  'message': instance.message,
  'totalLevels': instance.totalLevels,
  'difficulty_levels': instance.difficultyLevels
      ?.map((e) => e.toJson())
      .toList(),
};

DifficultyLevelResponse _$DifficultyLevelResponseFromJson(
  Map<String, dynamic> json,
) => DifficultyLevelResponse(
  id: json['id'] as String?,
  name: json['name'] as String?,
);

Map<String, dynamic> _$DifficultyLevelResponseToJson(
  DifficultyLevelResponse instance,
) => <String, dynamic>{'id': instance.id, 'name': instance.name};
