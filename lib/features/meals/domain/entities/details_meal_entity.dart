import 'package:equatable/equatable.dart';

class IngredientEntity extends Equatable {
  final String name;
  final String measure;

  const IngredientEntity({required this.name, required this.measure});

  @override
  List<Object?> get props => [name, measure];
}

class DetailsMealEntity extends Equatable {
  final String idMeal;
  final String strMeal;
  final String? strMealAlternate;
  final String strCategory;
  final String strArea;
  final String strInstructions;
  final String strMealThumb;
  final String strTags;
  final String strYoutube;
  final String strSource;
  final String? strImageSource;
  final String? strCreativeCommonsConfirmed;
  final String? dateModified;
  final List<IngredientEntity> ingredients;

  // ── Database / Chat Extended Fields (Nullable) ───────────────────────────
  final double? kcal;
  final double? proteinG;
  final double? carbsG;
  final double? fatG;
  final bool? vegetarian;
  final bool? vegan;
  final int? popularity;

  const DetailsMealEntity({
    required this.idMeal,
    required this.strMeal,
    this.strMealAlternate,
    required this.strCategory,
    required this.strArea,
    required this.strInstructions,
    required this.strMealThumb,
    required this.strTags,
    required this.strYoutube,
    required this.strSource,
    this.strImageSource,
    this.strCreativeCommonsConfirmed,
    this.dateModified,
    required this.ingredients,
    this.kcal,
    this.proteinG,
    this.carbsG,
    this.fatG,
    this.vegetarian,
    this.vegan,
    this.popularity,
  });

  @override
  List<Object?> get props => [
    idMeal,
    strMeal,
    strMealAlternate,
    strCategory,
    strArea,
    strInstructions,
    strMealThumb,
    strTags,
    strYoutube,
    strSource,
    strImageSource,
    strCreativeCommonsConfirmed,
    dateModified,
    ingredients,
    kcal,
    proteinG,
    carbsG,
    fatG,
    vegetarian,
    vegan,
    popularity,
  ];
}
