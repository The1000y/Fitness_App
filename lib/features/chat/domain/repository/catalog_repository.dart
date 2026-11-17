import '../entities/catalog_entities.dart';

abstract interface class CatalogRepository {
  /// Fetches distinct filter options (muscles, difficulties, equipments, meal categories, areas)
  /// from the local SQLite databases for prompt construction.
  Future<CatalogFilterMetadata> getFilterMetadata();

  /// Fast tool query returning exercise candidate entities matching filters.
  Future<List<ExerciseEntity>> getExercisesForTool({
    String? muscleGroup,
    String? difficulty,
    String? equipment,
    int limit = 8,
  });

  /// Fast tool query returning meal candidate entities matching filters.
  Future<List<MealEntity>> getMealsForTool({
    String? category,
    String? area,
    double? minProtein,
    double? maxKcal,
    bool? vegetarian,
    int limit = 8,
  });

  /// Resolves complete exercise entities by their unique IDs.
  Future<List<ExerciseEntity>> getExercisesByIds(List<String> ids);

  /// Resolves complete meal entities by their unique IDs.
  Future<List<MealEntity>> getMealsByIds(List<String> ids);
}
