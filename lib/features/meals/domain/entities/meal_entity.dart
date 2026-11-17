import 'package:equatable/equatable.dart';

class MealEntity extends Equatable {
  final String id;
  final String name;
  final String thumbnail;

  /// Only returned by some endpoints, so kept nullable.
  final String? area;
  final String? country;

  // ── Database / Chat Extended Fields (Nullable) ───────────────────────────
  final String? slug;
  final String? nameAr;
  final String? category;
  final String? mealType;
  final String? instructions;
  final double? kcal;
  final double? proteinG;
  final double? carbsG;
  final double? fatG;
  final int? servingsAssumed;
  final double? nutritionConfidence;
  final bool? nutritionIsEstimate;
  final bool? vegetarian;
  final bool? vegan;
  final bool? pescatarian;
  final bool? containsGluten;
  final bool? containsDairyOrEgg;
  final bool? containsNuts;
  final int? ingredientCount;
  final String? youtube;
  final String? source;
  final int? popularity;
  final String? dateModified;

  const MealEntity({
    required this.id,
    required this.name,
    required this.thumbnail,
    this.area,
    this.country,
    this.slug,
    this.nameAr,
    this.category,
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
    this.youtube,
    this.source,
    this.popularity,
    this.dateModified,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    thumbnail,
    area,
    country,
    slug,
    nameAr,
    category,
    mealType,
    instructions,
    kcal,
    proteinG,
    carbsG,
    fatG,
    servingsAssumed,
    nutritionConfidence,
    nutritionIsEstimate,
    vegetarian,
    vegan,
    pescatarian,
    containsGluten,
    containsDairyOrEgg,
    containsNuts,
    ingredientCount,
    youtube,
    source,
    popularity,
    dateModified,
  ];
}
