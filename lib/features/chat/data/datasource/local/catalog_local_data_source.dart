import '../../../domain/entities/catalog_filter_metadata.dart';
import '../../models/responses/exexercises_database_response/exercises_database_response.dart';
import '../../models/responses/meals_database_response/meals_database_response.dart';

abstract interface class CatalogLocalDataSource {
  /// Extracts distinct filter values from SQLite views to populate the LLM System Prompt.
  Future<CatalogFilterMetadata> getFilterMetadata();

  /// Fast query against `exercise_card` for the `get_exercises` tool.
  Future<List<Map<String, Object?>>> getExercisesForTool({
    String? muscleGroup,
    String? difficulty,
    String? equipment,
    int limit = 8,
  });

  /// Fast query against `meal_card` for the `get_meals` tool.
  Future<List<Map<String, Object?>>> getMealsForTool({
    String? category,
    String? area,
    double? minProtein,
    double? maxKcal,
    bool? vegetarian,
    int limit = 8,
  });

  /// Fetches raw exercise database records by their IDs wrapped in [ExercisesDatabaseResponse].
  Future<ExercisesDatabaseResponse> getExercisesByIds(List<String> ids);

  /// Fetches raw meal database records by their IDs wrapped in [MealsDatabaseResponse].
  Future<MealsDatabaseResponse> getMealsByIds(List<String> ids);
}
