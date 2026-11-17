import 'package:json_annotation/json_annotation.dart';

part 'meal_database_dto.g.dart';

/// One row of the `meal` table in meals.db (schema_version 1).
///
/// Column names are used as JSON keys, so a sqflite/drift row map
/// (`Map<String, Object?>`) can be passed straight to [MealDatabaseDTO.fromJson].
///
/// Boolean-like columns are stored by SQLite as INTEGER (0 / 1), so they are
/// kept as `int?` here and exposed as `bool` through the getters at the bottom.
@JsonSerializable()
class MealDatabaseDTO {
  // ── Identity ────────────────────────────────────────────────────────────
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'slug')
  final String? slug;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'name_ar')
  final String? nameAr;

  // ── Relations (FK → meal_category.id / meal_area.id) ────────────────────
  @JsonKey(name: 'category_id')
  final String? categoryId;

  @JsonKey(name: 'area_id')
  final String? areaId;

  // ── Classification / content ────────────────────────────────────────────
  /// breakfast | starter | main | side | dessert
  @JsonKey(name: 'meal_type')
  final String? mealType;

  @JsonKey(name: 'instructions')
  final String? instructions;

  // ── Nutrition (per serving; currently NULL for every row) ───────────────
  @JsonKey(name: 'kcal')
  final double? kcal;

  @JsonKey(name: 'protein_g')
  final double? proteinG;

  @JsonKey(name: 'carbs_g')
  final double? carbsG;

  @JsonKey(name: 'fat_g')
  final double? fatG;

  @JsonKey(name: 'servings_assumed')
  final int? servingsAssumed;

  @JsonKey(name: 'nutrition_confidence')
  final double? nutritionConfidence;

  /// 0 / 1 (DB default = 1)
  @JsonKey(name: 'nutrition_is_estimate')
  final int? nutritionIsEstimate;

  // ── Diet flags (0 / 1) ──────────────────────────────────────────────────
  @JsonKey(name: 'vegetarian')
  final int? vegetarian;

  @JsonKey(name: 'vegan')
  final int? vegan;

  @JsonKey(name: 'pescatarian')
  final int? pescatarian;

  @JsonKey(name: 'contains_gluten')
  final int? containsGluten;

  @JsonKey(name: 'contains_dairy_or_egg')
  final int? containsDairyOrEgg;

  @JsonKey(name: 'contains_nuts')
  final int? containsNuts;

  @JsonKey(name: 'ingredient_count')
  final int? ingredientCount;

  // ── Media / source ──────────────────────────────────────────────────────
  @JsonKey(name: 'thumb')
  final String? thumb;

  @JsonKey(name: 'image_small')
  final String? imageSmall;

  @JsonKey(name: 'image_medium')
  final String? imageMedium;

  @JsonKey(name: 'image_large')
  final String? imageLarge;

  @JsonKey(name: 'youtube')
  final String? youtube;

  @JsonKey(name: 'source')
  final String? source;

  /// "yyyy-MM-dd HH:mm:ss" (nullable)
  @JsonKey(name: 'date_modified')
  final String? dateModified;

  @JsonKey(name: 'popularity')
  final int? popularity;

  const MealDatabaseDTO({
    this.id,
    this.slug,
    this.name,
    this.nameAr,
    this.categoryId,
    this.areaId,
    this.mealType,
    this.instructions,
    this.kcal,
    this.proteinG,
    this.carbsG,
    this.fatG,
    this.servingsAssumed,
    this.nutritionConfidence,
    this.nutritionIsEstimate,
    this.vegetarian,
    this.vegan,
    this.pescatarian,
    this.containsGluten,
    this.containsDairyOrEgg,
    this.containsNuts,
    this.ingredientCount,
    this.thumb,
    this.imageSmall,
    this.imageMedium,
    this.imageLarge,
    this.youtube,
    this.source,
    this.dateModified,
    this.popularity,
  });

  factory MealDatabaseDTO.fromJson(Map<String, dynamic> json) =>
      _$MealDatabaseDTOFromJson(json);

  Map<String, dynamic> toJson() => _$MealDatabaseDTOToJson(this);

  // ── Convenience getters (ignored by json_serializable) ──────────────────
  bool get isEstimate => nutritionIsEstimate == 1;
  bool get isVegetarian => vegetarian == 1;
  bool get isVegan => vegan == 1;
  bool get isPescatarian => pescatarian == 1;
  bool get hasGluten => containsGluten == 1;
  bool get hasDairyOrEgg => containsDairyOrEgg == 1;
  bool get hasNuts => containsNuts == 1;
}
