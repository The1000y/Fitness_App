import 'package:equatable/equatable.dart';

class ExerciseEntity extends Equatable {
  final String id;
  final String exercise;
  final String difficultyLevel;
  final String targetMuscleGroup;
  final String primeMoverMuscle;
  final String? secondaryMuscle;
  final String? tertiaryMuscle;
  final String primaryEquipment;
  final String? secondaryEquipment;
  final String shortYoutubeDemonstrationLink;
  final String? inDepthYoutubeExplanationLink;
  final String bodyRegion;
  final String mechanics;

  const ExerciseEntity({
    required this.id,
    required this.exercise,
    required this.difficultyLevel,
    required this.targetMuscleGroup,
    required this.primeMoverMuscle,
    this.secondaryMuscle,
    this.tertiaryMuscle,
    required this.primaryEquipment,
    this.secondaryEquipment,
    required this.shortYoutubeDemonstrationLink,
    this.inDepthYoutubeExplanationLink,
    required this.bodyRegion,
    required this.mechanics,
  });

  @override
  List<Object?> get props => [
    id,
    exercise,
    difficultyLevel,
    targetMuscleGroup,
    primeMoverMuscle,
    secondaryMuscle,
    tertiaryMuscle,
    primaryEquipment,
    secondaryEquipment,
    shortYoutubeDemonstrationLink,
    inDepthYoutubeExplanationLink,
    bodyRegion,
    mechanics,
  ];
}
