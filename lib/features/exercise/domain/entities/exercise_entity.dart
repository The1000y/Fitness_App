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

  // ── Database / Chat Extended Fields (Nullable) ───────────────────────────
  final String? nameAr;
  final int? difficultyRank;
  final String? posture;
  final String? grip;
  final String? laterality;
  final String? forceType;
  final String? singleOrDoubleArm;
  final String? armsMode;
  final String? legsMode;
  final String? footElevation;
  final String? loadPositionEnding;
  final String? combinationExercises;
  final String? classification;
  final int? popularity;

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
    this.nameAr,
    this.difficultyRank,
    this.posture,
    this.grip,
    this.laterality,
    this.forceType,
    this.singleOrDoubleArm,
    this.armsMode,
    this.legsMode,
    this.footElevation,
    this.loadPositionEnding,
    this.combinationExercises,
    this.classification,
    this.popularity,
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
    nameAr,
    difficultyRank,
    posture,
    grip,
    laterality,
    forceType,
    singleOrDoubleArm,
    armsMode,
    legsMode,
    footElevation,
    loadPositionEnding,
    combinationExercises,
    classification,
    popularity,
  ];
}
