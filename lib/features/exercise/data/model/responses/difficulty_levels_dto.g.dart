// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'difficulty_levels_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DifficultyLevelsDto _$DifficultyLevelsDtoFromJson(Map<String, dynamic> json) =>
    DifficultyLevelsDto(
      message: json['message'] as String?,
      totalLevels: (json['totalLevels'] as num?)?.toInt(),
      difficultyLevels: (json['difficulty_levels'] as List<dynamic>?)
          ?.map((e) => DifficultyLevelDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DifficultyLevelsDtoToJson(
  DifficultyLevelsDto instance,
) => <String, dynamic>{
  'message': instance.message,
  'totalLevels': instance.totalLevels,
  'difficulty_levels': instance.difficultyLevels
      ?.map((e) => e.toJson())
      .toList(),
};

DifficultyLevelDto _$DifficultyLevelDtoFromJson(Map<String, dynamic> json) =>
    DifficultyLevelDto(
      id: json['id'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$DifficultyLevelDtoToJson(DifficultyLevelDto instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
