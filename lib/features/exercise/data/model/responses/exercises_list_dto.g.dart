// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercises_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExercisesListDto _$ExercisesListDtoFromJson(Map<String, dynamic> json) =>
    ExercisesListDto(
      message: json['message'] as String?,
      totalExercises: (json['totalExercises'] as num?)?.toInt(),
      totalPages: (json['totalPages'] as num?)?.toInt(),
      currentPage: (json['currentPage'] as num?)?.toInt(),
      exercises: (json['exercises'] as List<dynamic>?)
          ?.map((e) => ExerciseDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ExercisesListDtoToJson(ExercisesListDto instance) =>
    <String, dynamic>{
      'message': instance.message,
      'totalExercises': instance.totalExercises,
      'totalPages': instance.totalPages,
      'currentPage': instance.currentPage,
      'exercises': instance.exercises?.map((e) => e.toJson()).toList(),
    };
