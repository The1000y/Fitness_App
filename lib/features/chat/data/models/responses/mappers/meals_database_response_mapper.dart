import 'package:fitness_app/features/chat/data/models/responses/meals_database_response/meal_database_dto.dart';
import 'package:fitness_app/features/chat/data/models/responses/meals_database_response/meals_database_response.dart';
import 'package:fitness_app/features/meals/domain/entities/details_meal_entity.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_entity.dart';

extension MealDatabaseDtoMapper on MealDatabaseDTO {
  /// Maps to [MealEntity] populating both basic fields and extended database fields.
  MealEntity toEntity() => MealEntity(
    id: id ?? '',
    name: name ?? '',
    thumbnail: thumb ?? imageLarge ?? imageMedium ?? imageSmall ?? '',
    area: areaId,
    country: null,
    slug: slug,
    nameAr: nameAr,
    category: categoryId,
    mealType: mealType,
    instructions: instructions,
    kcal: kcal,
    proteinG: proteinG,
    carbsG: carbsG,
    fatG: fatG,
    servingsAssumed: servingsAssumed,
    nutritionConfidence: nutritionConfidence,
    nutritionIsEstimate: nutritionIsEstimate != null
        ? nutritionIsEstimate == 1
        : null,
    vegetarian: vegetarian != null ? vegetarian == 1 : null,
    vegan: vegan != null ? vegan == 1 : null,
    pescatarian: pescatarian != null ? pescatarian == 1 : null,
    containsGluten: containsGluten != null ? containsGluten == 1 : null,
    containsDairyOrEgg: containsDairyOrEgg != null
        ? containsDairyOrEgg == 1
        : null,
    containsNuts: containsNuts != null ? containsNuts == 1 : null,
    ingredientCount: ingredientCount,
    youtube: youtube,
    source: source,
    popularity: popularity,
    dateModified: dateModified,
  );

  /// Maps to [DetailsMealEntity] populating all details and nutrition fields.
  DetailsMealEntity toDetailsEntity() => DetailsMealEntity(
    idMeal: id ?? '',
    strMeal: name ?? '',
    strMealAlternate: nameAr,
    strCategory: categoryId ?? '',
    strArea: areaId ?? '',
    strInstructions: instructions ?? '',
    strMealThumb: thumb ?? imageLarge ?? imageMedium ?? imageSmall ?? '',
    strTags: mealType ?? '',
    strYoutube: youtube ?? '',
    strSource: source ?? '',
    dateModified: dateModified,
    ingredients: const [],
    kcal: kcal,
    proteinG: proteinG,
    carbsG: carbsG,
    fatG: fatG,
    vegetarian: vegetarian != null ? vegetarian == 1 : null,
    vegan: vegan != null ? vegan == 1 : null,
    popularity: popularity,
  );
}

extension MealsDatabaseResponseMapper on MealsDatabaseResponse {
  List<MealEntity> toEntity() =>
      meals?.map((e) => e.toEntity()).toList() ?? const [];

  List<DetailsMealEntity> toDetailsEntities() =>
      meals?.map((e) => e.toDetailsEntity()).toList() ?? const [];
}
