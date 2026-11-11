import 'package:json_annotation/json_annotation.dart';

part 'exercise_database_dto.g.dart';

/// One row of the `exercise` table in exercises.db (schema_version 1).
///
/// Column names are used as JSON keys, so a sqflite/drift row map
/// (`Map<String, Object?>`) can be passed straight to [ExerciseDatabaseDTO.fromJson].
@JsonSerializable()
class ExerciseDatabaseDTO {
  // ── Identity ────────────────────────────────────────────────────────────
  /// Stable slug, e.g. `stability-ball-dead-bug` (the only public reference).
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'name_ar')
  final String? nameAr;

  // ── Difficulty (FK → difficulty_level.id) ───────────────────────────────
  /// beginner | novice | intermediate | advanced | expert | master |
  /// grand-master | legendary
  @JsonKey(name: 'difficulty_id')
  final String? difficultyId;

  /// 1 (beginner) … 8 (legendary)
  @JsonKey(name: 'difficulty_rank')
  final int? difficultyRank;

  // ── Relations ───────────────────────────────────────────────────────────
  /// FK → muscle_group.id
  @JsonKey(name: 'muscle_group_id')
  final String? muscleGroupId;

  /// FK → muscle.id
  @JsonKey(name: 'prime_mover_id')
  final String? primeMoverId;

  /// FK → equipment.id
  @JsonKey(name: 'primary_equipment_id')
  final String? primaryEquipmentId;

  /// FK → equipment.id (nullable)
  @JsonKey(name: 'secondary_equipment_id')
  final String? secondaryEquipmentId;

  /// FK → body_region.id: full-body | lower-body | midsection | upper-body
  @JsonKey(name: 'body_region_id')
  final String? bodyRegionId;

  // ── Biomechanics / classification ───────────────────────────────────────
  @JsonKey(name: 'posture')
  final String? posture;

  @JsonKey(name: 'grip')
  final String? grip;

  /// Bilateral | Unilateral | Contralateral | Ipsilateral
  @JsonKey(name: 'laterality')
  final String? laterality;

  /// Compound | Isolation | Pull (nullable)
  @JsonKey(name: 'mechanics')
  final String? mechanics;

  /// Push | Pull | Push & Pull | Other | *Unsorted (nullable)
  @JsonKey(name: 'force_type')
  final String? forceType;

  /// Single Arm | Double Arm | No Arms
  @JsonKey(name: 'single_or_double_arm')
  final String? singleOrDoubleArm;

  /// Alternating | Continuous
  @JsonKey(name: 'arms_mode')
  final String? armsMode;

  /// Alternating | Continuous
  @JsonKey(name: 'legs_mode')
  final String? legsMode;

  @JsonKey(name: 'foot_elevation')
  final String? footElevation;

  @JsonKey(name: 'load_position_ending')
  final String? loadPositionEnding;

  /// Single Exercise | Combo Exercise
  @JsonKey(name: 'combination_exercises')
  final String? combinationExercises;

  /// e.g. Bodybuilding, Postural … (nullable)
  @JsonKey(name: 'classification')
  final String? classification;

  // ── Media ───────────────────────────────────────────────────────────────
  @JsonKey(name: 'demo_url')
  final String? demoUrl;

  @JsonKey(name: 'explain_url')
  final String? explainUrl;

  @JsonKey(name: 'popularity')
  final int? popularity;

  const ExerciseDatabaseDTO({
    this.id,
    this.name,
    this.nameAr,
    this.difficultyId,
    this.difficultyRank,
    this.muscleGroupId,
    this.primeMoverId,
    this.primaryEquipmentId,
    this.secondaryEquipmentId,
    this.bodyRegionId,
    this.posture,
    this.grip,
    this.laterality,
    this.mechanics,
    this.forceType,
    this.singleOrDoubleArm,
    this.armsMode,
    this.legsMode,
    this.footElevation,
    this.loadPositionEnding,
    this.combinationExercises,
    this.classification,
    this.demoUrl,
    this.explainUrl,
    this.popularity,
  });

  factory ExerciseDatabaseDTO.fromJson(Map<String, dynamic> json) =>
      _$ExerciseDatabaseDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseDatabaseDTOToJson(this);

  // ── Convenience getters (ignored by json_serializable) ──────────────────
  bool get isCombo => combinationExercises == 'Combo Exercise';
  bool get hasDemo => demoUrl != null && demoUrl!.isNotEmpty;
  bool get hasExplanation => explainUrl != null && explainUrl!.isNotEmpty;
}
