// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExerciseDto _$ExerciseDtoFromJson(Map<String, dynamic> json) => ExerciseDto(
  id: json['_id'] as String?,
  exercise: json['exercise'] as String?,
  difficultyLevel: json['difficulty_level'] as String?,
  targetMuscleGroup: json['target_muscle_group'] as String?,
  primeMoverMuscle: json['prime_mover_muscle'] as String?,
  secondaryMuscle: json['secondary_muscle'] as String?,
  tertiaryMuscle: json['tertiary_muscle'] as String?,
  primaryEquipment: json['primary_equipment'] as String?,
  secondaryEquipment: json['secondary_equipment'] as String?,
  shortYoutubeDemonstrationLink:
      json['short_youtube_demonstration_link'] as String?,
  inDepthYoutubeExplanationLink:
      json['in_depth_youtube_explanation_link'] as String?,
  bodyRegion: json['body_region'] as String?,
  mechanics: json['mechanics'] as String?,
);

Map<String, dynamic> _$ExerciseDtoToJson(
  ExerciseDto instance,
) => <String, dynamic>{
  '_id': instance.id,
  'exercise': instance.exercise,
  'difficulty_level': instance.difficultyLevel,
  'target_muscle_group': instance.targetMuscleGroup,
  'prime_mover_muscle': instance.primeMoverMuscle,
  'secondary_muscle': instance.secondaryMuscle,
  'tertiary_muscle': instance.tertiaryMuscle,
  'primary_equipment': instance.primaryEquipment,
  'secondary_equipment': instance.secondaryEquipment,
  'short_youtube_demonstration_link': instance.shortYoutubeDemonstrationLink,
  'in_depth_youtube_explanation_link': instance.inDepthYoutubeExplanationLink,
  'body_region': instance.bodyRegion,
  'mechanics': instance.mechanics,
};
