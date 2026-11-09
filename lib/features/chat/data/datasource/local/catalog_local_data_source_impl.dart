import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../../../domain/entities/catalog_filter_metadata.dart';
import '../../models/responses/exexercises_database_response/exercises_database_response.dart';
import '../../models/responses/meals_database_response/meals_database_response.dart';
import 'catalog_local_data_source.dart';

@Injectable(as: CatalogLocalDataSource)
class CatalogLocalDataSourceImpl implements CatalogLocalDataSource {
  Database? _exDb;
  Database? _mlDb;
  CatalogFilterMetadata? _cachedMeta;

  CatalogLocalDataSourceImpl();

  @visibleForTesting
  CatalogLocalDataSourceImpl.forTesting({
    Database? exercisesDb,
    Database? mealsDb,
  }) : _exDb = exercisesDb,
       _mlDb = mealsDb;

  Future<Database> get _exercisesDb async {
    if (_exDb != null && _exDb!.isOpen) return _exDb!;
    final dir = await getDatabasesPath();
    final dbPath = p.join(dir, 'exercises.db');
    if (kDebugMode) {
      debugPrint(
        'CatalogLocalDataSource: Opening exercises database at $dbPath',
      );
    }
    _exDb = await openDatabase(dbPath, readOnly: true);
    return _exDb!;
  }

  Future<Database> get _mealsDb async {
    if (_mlDb != null && _mlDb!.isOpen) return _mlDb!;
    final dir = await getDatabasesPath();
    final dbPath = p.join(dir, 'meals.db');
    if (kDebugMode) {
      debugPrint('CatalogLocalDataSource: Opening meals database at $dbPath');
    }
    _mlDb = await openDatabase(dbPath, readOnly: true);
    return _mlDb!;
  }

  @override
  Future<CatalogFilterMetadata> getFilterMetadata() async {
    if (_cachedMeta != null) {
      if (kDebugMode) {
        debugPrint('CatalogLocalDataSource: Returning cached filter metadata');
      }
      return _cachedMeta!;
    }

    if (kDebugMode) {
      debugPrint(
        'CatalogLocalDataSource: Fetching distinct filter metadata from SQLite',
      );
    }

    final exDb = await _exercisesDb;
    final mlDb = await _mealsDb;

    Future<List<String>> distinct(Database db, String table, String col) async {
      final rows = await db.rawQuery(
        'SELECT DISTINCT $col FROM $table WHERE $col IS NOT NULL ORDER BY $col',
      );
      return rows.map((r) => r[col].toString()).toList();
    }

    final muscleGroups = await distinct(exDb, 'exercise_card', 'muscle_group');
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

    _cachedMeta = CatalogFilterMetadata(
      muscleGroups: muscleGroups,
      difficulties: difficulties,
      equipments: equipments,
      mealCategories: mealCategories,
      mealAreas: mealAreas,
    );

    return _cachedMeta!;
  }

  @override
  Future<List<Map<String, Object?>>> getExercisesForTool({
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

    final db = await _exercisesDb;
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
        'muscle_group',
        'difficulty',
        'equipment',
        'body_region',
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

    return results;
  }

  @override
  Future<List<Map<String, Object?>>> getMealsForTool({
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

    final db = await _mealsDb;
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
        'category',
        'area',
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

    return results;
  }

  @override
  Future<ExercisesDatabaseResponse> getExercisesByIds(List<String> ids) async {
    if (kDebugMode) {
      debugPrint(
        'CatalogLocalDataSource: getExercisesByIds for ${ids.length} ids: $ids',
      );
    }

    if (ids.isEmpty) {
      return ExercisesDatabaseResponse(exercises: const []);
    }
    final db = await _exercisesDb;
    final ph = List.filled(ids.length, '?').join(',');
    List<Map<String, Object?>> rows;
    try {
      rows = await db.rawQuery('SELECT * FROM exercise WHERE id IN ($ph)', ids);
    } catch (_) {
      rows = await db.rawQuery(
        'SELECT * FROM exercise_card WHERE id IN ($ph)',
        ids,
      );
    }

    if (kDebugMode) {
      debugPrint(
        'CatalogLocalDataSource: getExercisesByIds resolved ${rows.length} rows',
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
      return MealsDatabaseResponse(meals: const []);
    }
    final db = await _mealsDb;
    final ph = List.filled(ids.length, '?').join(',');
    List<Map<String, Object?>> rows;
    try {
      rows = await db.rawQuery('SELECT * FROM meal WHERE id IN ($ph)', ids);
    } catch (_) {
      rows = await db.rawQuery(
        'SELECT * FROM meal_card WHERE id IN ($ph)',
        ids,
      );
    }

    if (kDebugMode) {
      debugPrint(
        'CatalogLocalDataSource: getMealsByIds resolved ${rows.length} rows',
      );
    }

    return MealsDatabaseResponse.fromRows(rows);
  }
}
