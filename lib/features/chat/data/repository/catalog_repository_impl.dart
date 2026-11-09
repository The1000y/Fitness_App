import 'package:injectable/injectable.dart';

import '../../domain/entities/catalog_entities.dart';
import '../../domain/repository/catalog_repository.dart';
import '../datasource/local/catalog_local_data_source.dart';
import '../models/responses/mappers/exercises_database_response_mapper.dart';
import '../models/responses/mappers/meals_database_response_mapper.dart';

@Injectable(as: CatalogRepository)
class CatalogRepositoryImpl implements CatalogRepository {
  final CatalogLocalDataSource _localDataSource;

  const CatalogRepositoryImpl(this._localDataSource);

  @override
  Future<CatalogFilterMetadata> getFilterMetadata() =>
      _localDataSource.getFilterMetadata();

  @override
  Future<List<Map<String, Object?>>> getExercisesForTool({
    String? muscleGroup,
    String? difficulty,
    String? equipment,
    int limit = 8,
  }) => _localDataSource.getExercisesForTool(
    muscleGroup: muscleGroup,
    difficulty: difficulty,
    equipment: equipment,
    limit: limit,
  );

  @override
  Future<List<Map<String, Object?>>> getMealsForTool({
    String? category,
    String? area,
    double? minProtein,
    double? maxKcal,
    bool? vegetarian,
    int limit = 8,
  }) => _localDataSource.getMealsForTool(
    category: category,
    area: area,
    minProtein: minProtein,
    maxKcal: maxKcal,
    vegetarian: vegetarian,
    limit: limit,
  );

  @override
  Future<List<ExerciseEntity>> getExercisesByIds(List<String> ids) =>
      _localDataSource.getExercisesByIds(ids).then((r) => r.toEntity());

  @override
  Future<List<MealEntity>> getMealsByIds(List<String> ids) =>
      _localDataSource.getMealsByIds(ids).then((r) => r.toEntity());
}
