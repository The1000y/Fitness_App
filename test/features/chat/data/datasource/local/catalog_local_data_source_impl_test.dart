import 'dart:io';

import 'package:fitness_app/core/database/exercises_database.dart';
import 'package:fitness_app/core/database/meals_database.dart';
import 'package:fitness_app/features/chat/data/datasource/local/catalog_local_data_source_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class MockExercisesDatabase extends Mock implements ExercisesDatabase {}

class MockMealsDatabase extends Mock implements MealsDatabase {}

void main() {
  late Database exercisesDb;
  late Database mealsDb;
  late MockExercisesDatabase exercisesDatabase;
  late MockMealsDatabase mealsDatabase;
  late CatalogLocalDataSourceImpl dataSource;

  setUpAll(sqfliteFfiInit);

  setUp(() async {
    final databaseDirectory = p.join(
      Directory.current.path,
      'assets',
      'databases',
    );
    exercisesDb = await databaseFactoryFfi.openDatabase(
      p.join(databaseDirectory, 'exercises.db'),
      options: OpenDatabaseOptions(readOnly: true),
    );
    mealsDb = await databaseFactoryFfi.openDatabase(
      p.join(databaseDirectory, 'meals.db'),
      options: OpenDatabaseOptions(readOnly: true),
    );

    exercisesDatabase = MockExercisesDatabase();
    mealsDatabase = MockMealsDatabase();
    when(() => exercisesDatabase.database).thenAnswer((_) async => exercisesDb);
    when(() => mealsDatabase.database).thenAnswer((_) async => mealsDb);

    dataSource = CatalogLocalDataSourceImpl(exercisesDatabase, mealsDatabase);
  });

  tearDown(() async {
    await exercisesDb.close();
    await mealsDb.close();
  });

  test('loads filter metadata from the bundled lookup tables', () async {
    final metadata = await dataSource.getFilterMetadata();

    expect(metadata.muscleGroups, isNotEmpty);
    expect(metadata.difficulties, isNotEmpty);
    expect(metadata.equipments, isNotEmpty);
    expect(metadata.mealCategories, isNotEmpty);
    expect(metadata.mealAreas, isNotEmpty);

    final muscleGroup = await exercisesDb.rawQuery('''
      SELECT muscle_group.name
      FROM exercise
      JOIN muscle_group ON muscle_group.id = exercise.muscle_group_id
      LIMIT 1
      ''');
    final category = await mealsDb.rawQuery('''
      SELECT meal_category.name
      FROM meal
      JOIN meal_category ON meal_category.id = meal.category_id
      LIMIT 1
      ''');

    expect(metadata.muscleGroups, contains(muscleGroup.single['name']));
    expect(metadata.mealCategories, contains(category.single['name']));
  });

  test(
    'queries exercises using the bundled exercise and lookup schemas',
    () async {
      final filterRows = await exercisesDb.rawQuery('''
      SELECT
        muscle_group.name AS muscle_group,
        difficulty_level.name AS difficulty,
        equipment.name AS equipment
      FROM exercise
      JOIN muscle_group ON muscle_group.id = exercise.muscle_group_id
      JOIN difficulty_level ON difficulty_level.id = exercise.difficulty_id
      JOIN equipment ON equipment.id = exercise.primary_equipment_id
      LIMIT 1
      ''');
      final filters = filterRows.single;

      final response = await dataSource.getExercisesForTool(
        muscleGroup: filters['muscle_group'] as String,
        difficulty: filters['difficulty'] as String,
        equipment: filters['equipment'] as String,
      );

      expect(response.exercises, isNotEmpty);
      expect(response.exercises!.first.muscleGroupId, filters['muscle_group']);
      expect(response.exercises!.first.difficultyId, filters['difficulty']);
      expect(
        response.exercises!.first.primaryEquipmentId,
        filters['equipment'],
      );

      final cappedResponse = await dataSource.getExercisesForTool(limit: 10000);
      expect(cappedResponse.exercises!.length, lessThanOrEqualTo(50));
    },
  );

  test('queries meals and resolves IDs from the bundled meal schema', () async {
    final filterRows = await mealsDb.rawQuery('''
      SELECT
        meal_category.name AS category,
        meal_area.name AS area
      FROM meal
      JOIN meal_category ON meal_category.id = meal.category_id
      JOIN meal_area ON meal_area.id = meal.area_id
      LIMIT 1
      ''');
    final filters = filterRows.single;

    final response = await dataSource.getMealsForTool(
      category: filters['category'] as String,
      area: filters['area'] as String,
    );

    expect(response.meals, isNotEmpty);
    expect(response.meals!.first.categoryId, filters['category']);
    expect(response.meals!.first.areaId, filters['area']);

    final exerciseId = await exercisesDb.rawQuery(
      'SELECT id FROM exercise LIMIT 1',
    );
    final mealId = await mealsDb.rawQuery('SELECT id FROM meal LIMIT 1');
    expect(
      (await dataSource.getExercisesByIds([
        exerciseId.single['id'] as String,
      ])).exercises,
      isNotEmpty,
    );
    expect(
      (await dataSource.getMealsByIds([mealId.single['id'] as String])).meals,
      isNotEmpty,
    );
  });
}
