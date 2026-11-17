import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

import 'package:fitness_app/core/database/exercises_database.dart';
import 'package:fitness_app/core/database/meals_database.dart';
import '../../../domain/entities/catalog_filter_metadata.dart';
import '../../models/responses/exexercises_database_response/exercises_database_response.dart';
import '../../models/responses/meals_database_response/meals_database_response.dart';
import 'catalog_local_data_source.dart';

@LazySingleton(as: CatalogLocalDataSource)
class CatalogLocalDataSourceImpl implements CatalogLocalDataSource {
  static const int _maxToolResults = 50;

  final ExercisesDatabase _exercisesDatabase;
  final MealsDatabase _mealsDatabase;

  Future<CatalogFilterMetadata>? _metadataFuture;
  String? _cachedExerciseTableName;
  String? _cachedMealTableName;

  CatalogLocalDataSourceImpl(this._exercisesDatabase, this._mealsDatabase);

  @override
  Future<CatalogFilterMetadata> getFilterMetadata() {
    _metadataFuture ??= _fetchFilterMetadata();
    return _metadataFuture!;
  }

  Future<CatalogFilterMetadata> _fetchFilterMetadata() async {
    try {
      if (kDebugMode) {
        debugPrint(
          'CatalogLocalDataSource: Fetching distinct filter metadata from SQLite',
        );
      }

      final exDb = await _exercisesDatabase.database;
      final mlDb = await _mealsDatabase.database;

      Future<List<String>> distinct(
        Database db,
        String query,
        String column,
      ) async {
        final rows = await db.rawQuery(query);
        return rows.map((row) => row[column].toString()).toList();
      }

      final muscleGroups = await distinct(exDb, '''
        SELECT DISTINCT mg.name AS value
        FROM exercise AS e
        JOIN muscle_group AS mg ON mg.id = e.muscle_group_id
        WHERE mg.name IS NOT NULL
        ORDER BY mg.name
        ''', 'value');
      final difficulties = await distinct(exDb, '''
        SELECT DISTINCT difficulty.name AS value
        FROM exercise AS e
        JOIN difficulty_level AS difficulty ON difficulty.id = e.difficulty_id
        WHERE difficulty.name IS NOT NULL
        ORDER BY difficulty.name
        ''', 'value');
      final equipments = await distinct(exDb, '''
        SELECT DISTINCT equipment.name AS value
        FROM exercise AS e
        JOIN equipment ON equipment.id = e.primary_equipment_id
        WHERE equipment.name IS NOT NULL
        ORDER BY equipment.name
        ''', 'value');
      final mealCategories = await distinct(mlDb, '''
        SELECT DISTINCT category.name AS value
        FROM meal
        JOIN meal_category AS category ON category.id = meal.category_id
        WHERE category.name IS NOT NULL
        ORDER BY category.name
        ''', 'value');
      final mealAreas = await distinct(mlDb, '''
        SELECT DISTINCT area.name AS value
        FROM meal
        JOIN meal_area AS area ON area.id = meal.area_id
        WHERE area.name IS NOT NULL
        ORDER BY area.name
        ''', 'value');

      if (kDebugMode) {
        debugPrint(
          'CatalogLocalDataSource: Loaded ${muscleGroups.length} muscles, '
          '${difficulties.length} difficulties, ${equipments.length} equipments, '
          '${mealCategories.length} categories, ${mealAreas.length} areas',
        );
      }

      return CatalogFilterMetadata(
        muscleGroups: muscleGroups,
        difficulties: difficulties,
        equipments: equipments,
        mealCategories: mealCategories,
        mealAreas: mealAreas,
      );
    } catch (e) {
      _metadataFuture = null;
      rethrow;
    }
  }

  @override
  Future<ExercisesDatabaseResponse> getExercisesForTool({
    String? muscleGroup,
    String? difficulty,
    String? equipment,
    int limit = 8,
  }) async {
    if (kDebugMode) {
      debugPrint(
        'CatalogLocalDataSource: getExercisesForTool called with '
        'muscleGroup=$muscleGroup, difficulty=$difficulty, equipment=$equipment, limit=$limit',
      );
    }

    final db = await _exercisesDatabase.database;
    final where = <String>[];
    final args = <Object?>[];

    if (muscleGroup != null && muscleGroup.isNotEmpty) {
      where.add('LOWER(muscle_group.name) = LOWER(?)');
      args.add(muscleGroup);
    }
    if (difficulty != null && difficulty.isNotEmpty) {
      where.add('LOWER(difficulty.name) = LOWER(?)');
      args.add(difficulty);
    }
    if (equipment != null && equipment.isNotEmpty) {
      where.add('LOWER(primary_equipment.name) = LOWER(?)');
      args.add(equipment);
    }

    final boundedLimit = _boundLimit(limit);
    final results = await db.rawQuery(
      '''
      SELECT
        exercise.id,
        exercise.name,
        exercise.name_ar,
        muscle_group.name AS muscle_group_id,
        difficulty.name AS difficulty_id,
        primary_equipment.name AS primary_equipment_id,
        exercise.body_region_id,
        exercise.mechanics
      FROM exercise
      LEFT JOIN muscle_group ON muscle_group.id = exercise.muscle_group_id
      LEFT JOIN difficulty_level AS difficulty
        ON difficulty.id = exercise.difficulty_id
      LEFT JOIN equipment AS primary_equipment
        ON primary_equipment.id = exercise.primary_equipment_id
      ${where.isEmpty ? '' : 'WHERE ${where.join(' AND ')}'}
      ORDER BY exercise.popularity DESC, exercise.difficulty_rank ASC,
        exercise.name ASC
      LIMIT ?
      ''',
      [...args, boundedLimit],
    );

    if (kDebugMode) {
      debugPrint(
        'CatalogLocalDataSource: getExercisesForTool found ${results.length} matches '
        '(limit=$boundedLimit)',
      );
    }

    return ExercisesDatabaseResponse.fromRows(results);
  }

  @override
  Future<MealsDatabaseResponse> getMealsForTool({
    String? category,
    String? area,
    double? minProtein,
    double? maxKcal,
    bool? vegetarian,
    int limit = 8,
  }) async {
    if (kDebugMode) {
      debugPrint(
        'CatalogLocalDataSource: getMealsForTool called with '
        'category=$category, area=$area, minProtein=$minProtein, maxKcal=$maxKcal, '
        'vegetarian=$vegetarian, limit=$limit',
      );
    }

    final db = await _mealsDatabase.database;
    final where = <String>[];
    final args = <Object?>[];

    if (category != null && category.isNotEmpty) {
      where.add('LOWER(category.name) = LOWER(?)');
      args.add(category);
    }
    if (area != null && area.isNotEmpty) {
      where.add('LOWER(area.name) = LOWER(?)');
      args.add(area);
    }
    if (minProtein != null) {
      where.add('protein_g >= ?');
      args.add(minProtein);
    }
    if (maxKcal != null) {
      where.add('kcal <= ?');
      args.add(maxKcal);
    }
    if (vegetarian == true) {
      where.add('vegetarian = 1');
    }

    final boundedLimit = _boundLimit(limit);
    final results = await db.rawQuery(
      '''
      SELECT
        meal.id,
        meal.name,
        meal.name_ar,
        category.name AS category_id,
        area.name AS area_id,
        meal.kcal,
        meal.protein_g,
        meal.carbs_g,
        meal.fat_g
      FROM meal
      LEFT JOIN meal_category AS category ON category.id = meal.category_id
      LEFT JOIN meal_area AS area ON area.id = meal.area_id
      ${where.isEmpty ? '' : 'WHERE ${where.join(' AND ')}'}
      ORDER BY (meal.protein_g IS NULL), meal.protein_g DESC,
        meal.popularity DESC
      LIMIT ?
      ''',
      [...args, boundedLimit],
    );

    if (kDebugMode) {
      debugPrint(
        'CatalogLocalDataSource: getMealsForTool found ${results.length} matches '
        '(limit=$boundedLimit)',
      );
    }

    return MealsDatabaseResponse.fromRows(results);
  }

  int _boundLimit(int limit) {
    if (limit < 1) return 1;
    if (limit > _maxToolResults) return _maxToolResults;
    return limit;
  }

  Future<String> _getExerciseTableName(Database db) async {
    if (_cachedExerciseTableName != null) return _cachedExerciseTableName!;
    final rows = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='exercise'",
    );
    _cachedExerciseTableName = rows.isNotEmpty ? 'exercise' : 'exercise_card';
    return _cachedExerciseTableName!;
  }

  Future<String> _getMealTableName(Database db) async {
    if (_cachedMealTableName != null) return _cachedMealTableName!;
    final rows = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='meal'",
    );
    _cachedMealTableName = rows.isNotEmpty ? 'meal' : 'meal_card';
    return _cachedMealTableName!;
  }

  @override
  Future<ExercisesDatabaseResponse> getExercisesByIds(List<String> ids) async {
    if (kDebugMode) {
      debugPrint(
        'CatalogLocalDataSource: getExercisesByIds for ${ids.length} ids: $ids',
      );
    }

    if (ids.isEmpty) {
      return const ExercisesDatabaseResponse(exercises: []);
    }

    final db = await _exercisesDatabase.database;
    final tableName = await _getExerciseTableName(db);
    final ph = List.filled(ids.length, '?').join(',');
    final rows = await db.rawQuery(
      'SELECT * FROM $tableName WHERE id IN ($ph)',
      ids,
    );

    if (kDebugMode) {
      debugPrint(
        'CatalogLocalDataSource: getExercisesByIds resolved ${rows.length} rows from $tableName',
      );
    }

    return ExercisesDatabaseResponse.fromRows(rows);
  }

  @override
  Future<MealsDatabaseResponse> getMealsByIds(List<String> ids) async {
    if (kDebugMode) {
      debugPrint(
        'CatalogLocalDataSource: getMealsByIds for ${ids.length} ids: $ids',
      );
    }

    if (ids.isEmpty) {
      return const MealsDatabaseResponse(meals: []);
    }

    final db = await _mealsDatabase.database;
    final tableName = await _getMealTableName(db);
    final ph = List.filled(ids.length, '?').join(',');
    final rows = await db.rawQuery(
      'SELECT * FROM $tableName WHERE id IN ($ph)',
      ids,
    );

    if (kDebugMode) {
      debugPrint(
        'CatalogLocalDataSource: getMealsByIds resolved ${rows.length} rows from $tableName',
      );
    }

    return MealsDatabaseResponse.fromRows(rows);
  }
}
