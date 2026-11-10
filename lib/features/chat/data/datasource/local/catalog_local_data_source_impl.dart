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
        String table,
        String col,
      ) async {
        final rows = await db.rawQuery(
          'SELECT DISTINCT $col FROM $table WHERE $col IS NOT NULL ORDER BY $col',
        );
        return rows.map((r) => r[col].toString()).toList();
      }

      final muscleGroups = await distinct(
        exDb,
        'exercise_card',
        'muscle_group',
      );
      final difficulties = await distinct(exDb, 'exercise_card', 'difficulty');
      final equipments = await distinct(exDb, 'exercise_card', 'equipment');
      final mealCategories = await distinct(mlDb, 'meal_card', 'category');
      final mealAreas = await distinct(mlDb, 'meal_card', 'area');

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
      where.add('LOWER(muscle_group) = LOWER(?)');
      args.add(muscleGroup);
    }
    if (difficulty != null && difficulty.isNotEmpty) {
      where.add('LOWER(difficulty) = LOWER(?)');
      args.add(difficulty);
    }
    if (equipment != null && equipment.isNotEmpty) {
      where.add('LOWER(equipment) = LOWER(?)');
      args.add(equipment);
    }

    final results = await db.query(
      'exercise_card',
      columns: [
        'id',
        'name',
        'name_ar',
        'muscle_group AS muscle_group_id',
        'difficulty AS difficulty_id',
        'equipment AS primary_equipment_id',
        'body_region AS body_region_id',
        'mechanics',
      ],
      where: where.isEmpty ? null : where.join(' AND '),
      whereArgs: args,
      orderBy: 'popularity DESC, difficulty_rank ASC, name ASC',
      limit: limit,
    );

    if (kDebugMode) {
      debugPrint(
        'CatalogLocalDataSource: getExercisesForTool found ${results.length} matches',
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
      where.add('LOWER(category) = LOWER(?)');
      args.add(category);
    }
    if (area != null && area.isNotEmpty) {
      where.add('LOWER(area) = LOWER(?)');
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

    final results = await db.query(
      'meal_card',
      columns: [
        'id',
        'name',
        'name_ar',
        'category AS category_id',
        'area AS area_id',
        'kcal',
        'protein_g',
        'carbs_g',
        'fat_g',
      ],
      where: where.isEmpty ? null : where.join(' AND '),
      whereArgs: args,
      orderBy: '(protein_g IS NULL), protein_g DESC, popularity DESC',
      limit: limit,
    );

    if (kDebugMode) {
      debugPrint(
        'CatalogLocalDataSource: getMealsForTool found ${results.length} matches',
      );
    }

    return MealsDatabaseResponse.fromRows(results);
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
