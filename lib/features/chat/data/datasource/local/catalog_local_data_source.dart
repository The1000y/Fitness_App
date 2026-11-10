import '../../../domain/entities/catalog_filter_metadata.dart';
import '../../models/responses/exexercises_database_response/exercises_database_response.dart';
import '../../models/responses/meals_database_response/meals_database_response.dart';

abstract interface class CatalogLocalDataSource {
  /// Fetches distinct filter values across both databases with in-memory caching.
  Future<CatalogFilterMetadata> getFilterMetadata();

  /// Fast tool query against `exercise_card` returning matching candidate DTOs.
  Future<ExercisesDatabaseResponse> getExercisesForTool({
    String? muscleGroup,
    String? difficulty,
    String? equipment,
    int limit = 8,
  });

  /// Fast tool query against `meal_card` returning matching candidate DTOs.
  Future<MealsDatabaseResponse> getMealsForTool({
    String? category,
    String? area,
    double? minProtein,
    double? maxKcal,
    bool? vegetarian,
    int limit = 8,
  });

  /// Batch resolves complete exercise rows from `exercise` (or `exercise_card`) by IDs.
  Future<ExercisesDatabaseResponse> getExercisesByIds(List<String> ids);

  /// Batch resolves complete meal rows from `meal` (or `meal_card`) by IDs.
  Future<MealsDatabaseResponse> getMealsByIds(List<String> ids);
}
