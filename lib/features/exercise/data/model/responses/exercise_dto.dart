import 'package:json_annotation/json_annotation.dart';

import 'package:fitness_app/features/exercise/domain/entities/exercise_entity.dart';

part 'exercise_dto.g.dart';

@JsonSerializable()
class ExerciseDto {
  @JsonKey(name: '_id')
  final String? id;
  final String? exercise;
  @JsonKey(name: 'difficulty_level')
  final String? difficultyLevel;
  @JsonKey(name: 'target_muscle_group')
  final String? targetMuscleGroup;
  @JsonKey(name: 'prime_mover_muscle')
  final String? primeMoverMuscle;
  @JsonKey(name: 'secondary_muscle')
  final String? secondaryMuscle;
  @JsonKey(name: 'tertiary_muscle')
  final String? tertiaryMuscle;
  @JsonKey(name: 'primary_equipment')
  final String? primaryEquipment;
  @JsonKey(name: 'secondary_equipment')
  final String? secondaryEquipment;
  @JsonKey(name: 'short_youtube_demonstration_link')
  final String? shortYoutubeDemonstrationLink;
  @JsonKey(name: 'in_depth_youtube_explanation_link')
  final String? inDepthYoutubeExplanationLink;
  @JsonKey(name: 'body_region')
  final String? bodyRegion;
  final String? mechanics;

  ExerciseDto({
    this.id,
    this.exercise,
    this.difficultyLevel,
    this.targetMuscleGroup,
    this.primeMoverMuscle,
    this.secondaryMuscle,
    this.tertiaryMuscle,
    this.primaryEquipment,
    this.secondaryEquipment,
    this.shortYoutubeDemonstrationLink,
    this.inDepthYoutubeExplanationLink,
    this.bodyRegion,
    this.mechanics,
  });

  factory ExerciseDto.fromJson(Map<String, dynamic> json) =>
      _$ExerciseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseDtoToJson(this);

  ExerciseEntity toEntity() {
    return ExerciseEntity(
      id: id ?? '',
      exercise: exercise ?? '',
      difficultyLevel: difficultyLevel ?? '',
      targetMuscleGroup: targetMuscleGroup ?? '',
      primeMoverMuscle: primeMoverMuscle ?? '',
      secondaryMuscle: secondaryMuscle,
      tertiaryMuscle: tertiaryMuscle,
      primaryEquipment: primaryEquipment ?? '',
      secondaryEquipment: secondaryEquipment,
      shortYoutubeDemonstrationLink: shortYoutubeDemonstrationLink ?? '',
      inDepthYoutubeExplanationLink: inDepthYoutubeExplanationLink,
      bodyRegion: bodyRegion ?? '',
      mechanics: mechanics ?? '',
    );
  }
}
