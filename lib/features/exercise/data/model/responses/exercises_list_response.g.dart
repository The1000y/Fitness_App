// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercises_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExercisesListResponse _$ExercisesListResponseFromJson(
  Map<String, dynamic> json,
) => ExercisesListResponse(
  message: json['message'] as String?,
  totalExercises: (json['totalExercises'] as num?)?.toInt(),
  totalPages: (json['totalPages'] as num?)?.toInt(),
  currentPage: (json['currentPage'] as num?)?.toInt(),
  exercises: (json['exercises'] as List<dynamic>?)
      ?.map((e) => ExerciseResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ExercisesListResponseToJson(
  ExercisesListResponse instance,
) => <String, dynamic>{
  'message': instance.message,
  'totalExercises': instance.totalExercises,
  'totalPages': instance.totalPages,
  'currentPage': instance.currentPage,
  'exercises': instance.exercises?.map((e) => e.toJson()).toList(),
};
