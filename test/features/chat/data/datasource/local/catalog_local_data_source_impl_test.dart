import 'package:fitness_app/core/database/exercises_database.dart';
import 'package:fitness_app/core/database/meals_database.dart';
import 'package:fitness_app/features/chat/data/datasource/local/catalog_local_data_source_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';

class MockDatabase extends Mock implements Database {}

class MockExercisesDatabase extends Mock implements ExercisesDatabase {}

class MockMealsDatabase extends Mock implements MealsDatabase {}

void main() {
  late MockDatabase mockExercisesDb;
  late MockDatabase mockMealsDb;
  late MockExercisesDatabase mockExercisesDbWrapper;
  late MockMealsDatabase mockMealsDbWrapper;
  late CatalogLocalDataSourceImpl dataSource;

  setUp(() {
    mockExercisesDb = MockDatabase();
    mockMealsDb = MockDatabase();
    mockExercisesDbWrapper = MockExercisesDatabase();
    mockMealsDbWrapper = MockMealsDatabase();

    when(
      () => mockExercisesDbWrapper.database,
    ).thenAnswer((_) async => mockExercisesDb);
    when(
      () => mockMealsDbWrapper.database,
    ).thenAnswer((_) async => mockMealsDb);

    dataSource = CatalogLocalDataSourceImpl(
      mockExercisesDbWrapper,
      mockMealsDbWrapper,
    );
  });

  group('CatalogLocalDataSourceImpl - getFilterMetadata', () {
    test(
      'fetches distinct values from SQLite and caches the Future preventing race conditions',
      () async {
        when(
          () => mockExercisesDb.rawQuery(
            'SELECT DISTINCT muscle_group FROM exercise_card WHERE muscle_group IS NOT NULL ORDER BY muscle_group',
          ),
        ).thenAnswer(
          (_) async => [
            {'muscle_group': 'Chest'},
            {'muscle_group': 'Back'},
          ],
        );

        when(
          () => mockExercisesDb.rawQuery(
            'SELECT DISTINCT difficulty FROM exercise_card WHERE difficulty IS NOT NULL ORDER BY difficulty',
          ),
        ).thenAnswer(
          (_) async => [
            {'difficulty': 'Beginner'},
            {'difficulty': 'Intermediate'},
          ],
        );

        when(
          () => mockExercisesDb.rawQuery(
            'SELECT DISTINCT equipment FROM exercise_card WHERE equipment IS NOT NULL ORDER BY equipment',
          ),
        ).thenAnswer(
          (_) async => [
            {'equipment': 'Dumbbell'},
            {'equipment': 'Barbell'},
          ],
        );

        when(
          () => mockMealsDb.rawQuery(
            'SELECT DISTINCT category FROM meal_card WHERE category IS NOT NULL ORDER BY category',
          ),
        ).thenAnswer(
          (_) async => [
            {'category': 'Chicken'},
            {'category': 'Beef'},
          ],
        );

        when(
          () => mockMealsDb.rawQuery(
            'SELECT DISTINCT area FROM meal_card WHERE area IS NOT NULL ORDER BY area',
          ),
        ).thenAnswer(
          (_) async => [
            {'area': 'American'},
            {'area': 'Italian'},
          ],
        );

        // Trigger two concurrent calls simultaneously
        final future1 = dataSource.getFilterMetadata();
        final future2 = dataSource.getFilterMetadata();

        // Both should return the exact same Future instance
        expect(identical(future1, future2), isTrue);

        final metadata = await future1;
        final metadata2 = await future2;

        expect(identical(metadata, metadata2), isTrue);
        expect(metadata.muscleGroups, ['Chest', 'Back']);
        expect(metadata.difficulties, ['Beginner', 'Intermediate']);
        expect(metadata.equipments, ['Dumbbell', 'Barbell']);
        expect(metadata.mealCategories, ['Chicken', 'Beef']);
        expect(metadata.mealAreas, ['American', 'Italian']);

        // Queries should be executed only once
        verify(() => mockExercisesDb.rawQuery(any())).called(3);
        verify(() => mockMealsDb.rawQuery(any())).called(2);
      },
    );

    test('resets future cache on error allowing subsequent retries', () async {
      when(
        () => mockExercisesDb.rawQuery(any()),
      ).thenThrow(Exception('DB error'));

      await expectLater(
        () => dataSource.getFilterMetadata(),
        throwsA(isA<Exception>()),
      );

      // Now mock success
      when(
        () => mockExercisesDb.rawQuery(
          'SELECT DISTINCT muscle_group FROM exercise_card WHERE muscle_group IS NOT NULL ORDER BY muscle_group',
        ),
      ).thenAnswer(
        (_) async => [
          {'muscle_group': 'Legs'},
        ],
      );
      when(
        () => mockExercisesDb.rawQuery(
          'SELECT DISTINCT difficulty FROM exercise_card WHERE difficulty IS NOT NULL ORDER BY difficulty',
        ),
      ).thenAnswer((_) async => []);
      when(
        () => mockExercisesDb.rawQuery(
          'SELECT DISTINCT equipment FROM exercise_card WHERE equipment IS NOT NULL ORDER BY equipment',
        ),
      ).thenAnswer((_) async => []);
      when(() => mockMealsDb.rawQuery(any())).thenAnswer((_) async => []);

      final result = await dataSource.getFilterMetadata();
      expect(result.muscleGroups, ['Legs']);
    });
  });

  group('CatalogLocalDataSourceImpl - getExercisesForTool', () {
    test(
      'queries exercise_card and returns ExercisesDatabaseResponse',
      () async {
        final mockResults = [
          {
            'id': 'ex-1',
            'name': 'Push Up',
            'name_ar': 'ضغط',
            'muscle_group_id': 'Chest',
            'difficulty_id': 'Beginner',
            'primary_equipment_id': 'Bodyweight',
            'body_region_id': 'upper_body',
            'mechanics': 'compound',
          },
        ];

        when(
          () => mockExercisesDb.query(
            'exercise_card',
            columns: any(named: 'columns'),
            where: null,
            whereArgs: [],
            orderBy: 'popularity DESC, difficulty_rank ASC, name ASC',
            limit: 8,
          ),
        ).thenAnswer((_) async => mockResults);

        final response = await dataSource.getExercisesForTool();

        expect(response.exercises, isNotNull);
        expect(response.exercises!.length, 1);
        expect(response.exercises!.first.id, 'ex-1');
        expect(response.exercises!.first.name, 'Push Up');
        expect(response.exercises!.first.muscleGroupId, 'Chest');
        expect(response.exercises!.first.difficultyId, 'Beginner');

        verify(
          () => mockExercisesDb.query(
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
            where: null,
            whereArgs: [],
            orderBy: 'popularity DESC, difficulty_rank ASC, name ASC',
            limit: 8,
          ),
        ).called(1);
      },
    );

    test('queries exercise_card with filter criteria and custom limit', () async {
      final mockResults = [
        {
          'id': 'ex-2',
          'name': 'Dumbbell Press',
          'muscle_group_id': 'Chest',
          'difficulty_id': 'Intermediate',
          'primary_equipment_id': 'Dumbbell',
        },
      ];

      when(
        () => mockExercisesDb.query(
          'exercise_card',
          columns: any(named: 'columns'),
          where:
              'LOWER(muscle_group) = LOWER(?) AND LOWER(difficulty) = LOWER(?) AND LOWER(equipment) = LOWER(?)',
          whereArgs: ['Chest', 'Intermediate', 'Dumbbell'],
          orderBy: 'popularity DESC, difficulty_rank ASC, name ASC',
          limit: 4,
        ),
      ).thenAnswer((_) async => mockResults);

      final response = await dataSource.getExercisesForTool(
        muscleGroup: 'Chest',
        difficulty: 'Intermediate',
        equipment: 'Dumbbell',
        limit: 4,
      );

      expect(response.exercises?.first.id, 'ex-2');
      verify(
        () => mockExercisesDb.query(
          'exercise_card',
          columns: any(named: 'columns'),
          where:
              'LOWER(muscle_group) = LOWER(?) AND LOWER(difficulty) = LOWER(?) AND LOWER(equipment) = LOWER(?)',
          whereArgs: ['Chest', 'Intermediate', 'Dumbbell'],
          orderBy: 'popularity DESC, difficulty_rank ASC, name ASC',
          limit: 4,
        ),
      ).called(1);
    });
  });

  group('CatalogLocalDataSourceImpl - getMealsForTool', () {
    test('queries meal_card and returns MealsDatabaseResponse', () async {
      final mockResults = [
        {
          'id': 'meal-1',
          'name': 'Grilled Chicken',
          'category_id': 'Chicken',
          'area_id': 'American',
          'kcal': 350.0,
          'protein_g': 30.0,
        },
      ];

      when(
        () => mockMealsDb.query(
          'meal_card',
          columns: any(named: 'columns'),
          where: null,
          whereArgs: [],
          orderBy: '(protein_g IS NULL), protein_g DESC, popularity DESC',
          limit: 8,
        ),
      ).thenAnswer((_) async => mockResults);

      final response = await dataSource.getMealsForTool();

      expect(response.meals, isNotNull);
      expect(response.meals!.length, 1);
      expect(response.meals!.first.id, 'meal-1');
      expect(response.meals!.first.name, 'Grilled Chicken');
      expect(response.meals!.first.categoryId, 'Chicken');
      expect(response.meals!.first.areaId, 'American');

      verify(
        () => mockMealsDb.query(
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
          where: null,
          whereArgs: [],
          orderBy: '(protein_g IS NULL), protein_g DESC, popularity DESC',
          limit: 8,
        ),
      ).called(1);
    });

    test(
      'queries meal_card with filters for category, area, protein, kcal, and vegetarian',
      () async {
        final mockResults = [
          {
            'id': 'meal-2',
            'name': 'Tofu Salad',
            'category_id': 'Salad',
            'area_id': 'Greek',
            'kcal': 280.0,
            'protein_g': 20.0,
          },
        ];

        when(
          () => mockMealsDb.query(
            'meal_card',
            columns: any(named: 'columns'),
            where:
                'LOWER(category) = LOWER(?) AND LOWER(area) = LOWER(?) AND protein_g >= ? AND kcal <= ? AND vegetarian = 1',
            whereArgs: ['Salad', 'Greek', 15.0, 400.0],
            orderBy: '(protein_g IS NULL), protein_g DESC, popularity DESC',
            limit: 5,
          ),
        ).thenAnswer((_) async => mockResults);

        final response = await dataSource.getMealsForTool(
          category: 'Salad',
          area: 'Greek',
          minProtein: 15.0,
          maxKcal: 400.0,
          vegetarian: true,
          limit: 5,
        );

        expect(response.meals?.first.id, 'meal-2');
      },
    );
  });

  group('CatalogLocalDataSourceImpl - getExercisesByIds', () {
    test(
      'returns empty ExercisesDatabaseResponse immediately when ids list is empty',
      () async {
        final response = await dataSource.getExercisesByIds([]);

        expect(response.exercises, isEmpty);
        verifyZeroInteractions(mockExercisesDb);
      },
    );

    test(
      'checks sqlite_master and queries exercise table when it exists',
      () async {
        final rows = [
          {
            'id': 'ex-1',
            'name': 'Bench Press',
            'difficulty_id': 'intermediate',
            'muscle_group_id': 'chest',
            'demo_url': 'https://youtube.com/bench',
          },
        ];

        when(
          () => mockExercisesDb.rawQuery(
            "SELECT name FROM sqlite_master WHERE type='table' AND name='exercise'",
          ),
        ).thenAnswer(
          (_) async => [
            {'name': 'exercise'},
          ],
        );

        when(
          () => mockExercisesDb.rawQuery(
            'SELECT * FROM exercise WHERE id IN (?)',
            ['ex-1'],
          ),
        ).thenAnswer((_) async => rows);

        final response = await dataSource.getExercisesByIds(['ex-1']);

        expect(response.exercises?.length, 1);
        expect(response.exercises?.first.id, 'ex-1');
        expect(response.exercises?.first.name, 'Bench Press');

        verify(
          () => mockExercisesDb.rawQuery(
            "SELECT name FROM sqlite_master WHERE type='table' AND name='exercise'",
          ),
        ).called(1);
        verify(
          () => mockExercisesDb.rawQuery(
            'SELECT * FROM exercise WHERE id IN (?)',
            ['ex-1'],
          ),
        ).called(1);
      },
    );

    test(
      'checks sqlite_master and falls back to exercise_card table when exercise table is absent',
      () async {
        final rows = [
          {
            'id': 'ex-2',
            'name': 'Incline Dumbbell Press',
            'difficulty_id': 'intermediate',
          },
        ];

        when(
          () => mockExercisesDb.rawQuery(
            "SELECT name FROM sqlite_master WHERE type='table' AND name='exercise'",
          ),
        ).thenAnswer((_) async => []);

        when(
          () => mockExercisesDb.rawQuery(
            'SELECT * FROM exercise_card WHERE id IN (?)',
            ['ex-2'],
          ),
        ).thenAnswer((_) async => rows);

        final response = await dataSource.getExercisesByIds(['ex-2']);

        expect(response.exercises?.first.id, 'ex-2');
        verify(
          () => mockExercisesDb.rawQuery(
            'SELECT * FROM exercise_card WHERE id IN (?)',
            ['ex-2'],
          ),
        ).called(1);
      },
    );
  });

  group('CatalogLocalDataSourceImpl - getMealsByIds', () {
    test(
      'returns empty MealsDatabaseResponse immediately when ids list is empty',
      () async {
        final response = await dataSource.getMealsByIds([]);

        expect(response.meals, isEmpty);
        verifyZeroInteractions(mockMealsDb);
      },
    );

    test(
      'checks sqlite_master and queries meal table when it exists',
      () async {
        final rows = [
          {
            'id': 'meal-1',
            'name': 'Chicken Breast',
            'thumb': 'https://example.com/chicken.jpg',
            'category_id': 'chicken',
            'area_id': 'american',
            'kcal': 250.0,
            'protein_g': 35.0,
          },
        ];

        when(
          () => mockMealsDb.rawQuery(
            "SELECT name FROM sqlite_master WHERE type='table' AND name='meal'",
          ),
        ).thenAnswer(
          (_) async => [
            {'name': 'meal'},
          ],
        );

        when(
          () => mockMealsDb.rawQuery('SELECT * FROM meal WHERE id IN (?)', [
            'meal-1',
          ]),
        ).thenAnswer((_) async => rows);

        final response = await dataSource.getMealsByIds(['meal-1']);

        expect(response.meals?.length, 1);
        expect(response.meals?.first.id, 'meal-1');
        expect(response.meals?.first.thumb, 'https://example.com/chicken.jpg');

        verify(
          () => mockMealsDb.rawQuery(
            "SELECT name FROM sqlite_master WHERE type='table' AND name='meal'",
          ),
        ).called(1);
        verify(
          () => mockMealsDb.rawQuery('SELECT * FROM meal WHERE id IN (?)', [
            'meal-1',
          ]),
        ).called(1);
      },
    );

    test(
      'checks sqlite_master and falls back to meal_card table when meal table is absent',
      () async {
        final rows = [
          {
            'id': 'meal-2',
            'name': 'Beef Steak',
            'category_id': 'beef',
            'area_id': 'american',
          },
        ];

        when(
          () => mockMealsDb.rawQuery(
            "SELECT name FROM sqlite_master WHERE type='table' AND name='meal'",
          ),
        ).thenAnswer((_) async => []);

        when(
          () => mockMealsDb.rawQuery(
            'SELECT * FROM meal_card WHERE id IN (?)',
            ['meal-2'],
          ),
        ).thenAnswer((_) async => rows);

        final response = await dataSource.getMealsByIds(['meal-2']);

        expect(response.meals?.first.id, 'meal-2');
        verify(
          () => mockMealsDb.rawQuery(
            'SELECT * FROM meal_card WHERE id IN (?)',
            ['meal-2'],
          ),
        ).called(1);
      },
    );
  });
}
