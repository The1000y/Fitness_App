import 'package:fitness_app/features/chat/data/models/responses/exexercises_database_response/exercises_database_response.dart';
import 'package:fitness_app/features/exercise/domain/entities/exercise_entity.dart';

extension ExerciseDatabaseDtoMapper on ExerciseDatabaseDTO {
  /// Maps to [ExerciseEntity] populating both basic fields and extended biomechanical / database fields.
  ExerciseEntity toEntity() => ExerciseEntity(
    id: id ?? '',
    exercise: name ?? '',
    difficultyLevel: difficultyId ?? '',
    targetMuscleGroup: muscleGroupId ?? '',
    primeMoverMuscle: primeMoverId ?? '',
    secondaryMuscle: null,
    tertiaryMuscle: null,
    primaryEquipment: primaryEquipmentId ?? '',
    secondaryEquipment: secondaryEquipmentId,
    shortYoutubeDemonstrationLink: demoUrl ?? '',
    inDepthYoutubeExplanationLink: explainUrl,
    bodyRegion: bodyRegionId ?? '',
    mechanics: mechanics ?? '',
    nameAr: nameAr,
    difficultyRank: difficultyRank,
    posture: posture,
    grip: grip,
    laterality: laterality,
    forceType: forceType,
    singleOrDoubleArm: singleOrDoubleArm,
    armsMode: armsMode,
    legsMode: legsMode,
    footElevation: footElevation,
    loadPositionEnding: loadPositionEnding,
    combinationExercises: combinationExercises,
    classification: classification,
    popularity: popularity,
  );
}

extension ExercisesDatabaseResponseMapper on ExercisesDatabaseResponse {
  List<ExerciseEntity> toEntity() =>
      exercises?.map((e) => e.toEntity()).toList() ?? const [];
}
