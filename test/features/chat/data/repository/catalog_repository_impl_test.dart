import 'package:fitness_app/features/chat/data/datasource/local/catalog_local_data_source.dart';
import 'package:fitness_app/features/chat/data/models/responses/exexercises_database_response/exercises_database_response.dart';
import 'package:fitness_app/features/chat/data/models/responses/meals_database_response/meal_database_dto.dart';
import 'package:fitness_app/features/chat/data/models/responses/meals_database_response/meals_database_response.dart';
import 'package:fitness_app/features/chat/data/repository/catalog_repository_impl.dart';
import 'package:fitness_app/features/chat/domain/entities/catalog_entities.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCatalogLocalDataSource extends Mock
    implements CatalogLocalDataSource {}

void main() {
  late MockCatalogLocalDataSource mockLocalDataSource;
  late CatalogRepositoryImpl repository;

  setUp(() {
    mockLocalDataSource = MockCatalogLocalDataSource();
    repository = CatalogRepositoryImpl(mockLocalDataSource);
  });

  group('CatalogRepositoryImpl', () {
    test('getFilterMetadata delegates to localDataSource', () async {
      const expectedMeta = CatalogFilterMetadata(
        muscleGroups: ['Chest'],
        difficulties: ['Beginner'],
        equipments: ['Dumbbell'],
        mealCategories: ['High Protein'],
        mealAreas: ['Middle Eastern'],
      );

      when(
        () => mockLocalDataSource.getFilterMetadata(),
      ).thenAnswer((_) async => expectedMeta);

      final result = await repository.getFilterMetadata();

      expect(result, equals(expectedMeta));
      verify(() => mockLocalDataSource.getFilterMetadata()).called(1);
    });

    test('getExercisesForTool delegates to localDataSource', () async {
      final expectedExercises = [
        {'id': 'ex-1', 'name': 'Push Up'},
      ];

      when(
        () => mockLocalDataSource.getExercisesForTool(
          muscleGroup: any(named: 'muscleGroup'),
          difficulty: any(named: 'difficulty'),
          equipment: any(named: 'equipment'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => expectedExercises);

      final result = await repository.getExercisesForTool(
        muscleGroup: 'Chest',
        difficulty: 'Beginner',
        equipment: 'Bodyweight',
        limit: 5,
      );

      expect(result, equals(expectedExercises));
      verify(
        () => mockLocalDataSource.getExercisesForTool(
          muscleGroup: 'Chest',
          difficulty: 'Beginner',
          equipment: 'Bodyweight',
          limit: 5,
        ),
      ).called(1);
    });

    test('getMealsForTool delegates to localDataSource', () async {
      final expectedMeals = [
        {'id': 'meal-1', 'name': 'Chicken Salad'},
      ];

      when(
        () => mockLocalDataSource.getMealsForTool(
          category: any(named: 'category'),
          area: any(named: 'area'),
          minProtein: any(named: 'minProtein'),
          maxKcal: any(named: 'maxKcal'),
          vegetarian: any(named: 'vegetarian'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => expectedMeals);

      final result = await repository.getMealsForTool(
        category: 'Chicken',
        area: 'American',
        minProtein: 30.0,
        maxKcal: 500.0,
        vegetarian: false,
        limit: 8,
      );

      expect(result, equals(expectedMeals));
      verify(
        () => mockLocalDataSource.getMealsForTool(
          category: 'Chicken',
          area: 'American',
          minProtein: 30.0,
          maxKcal: 500.0,
          vegetarian: false,
          limit: 8,
        ),
      ).called(1);
    });

    test('getExercisesByIds maps response to ExerciseEntity list', () async {
      final response = ExercisesDatabaseResponse(
        exercises: const [
          ExerciseDatabaseDTO(
            id: 'ex-1',
            name: 'Bench Press',
            difficultyId: 'intermediate',
            muscleGroupId: 'chest',
            primeMoverId: 'pectoralis_major',
            primaryEquipmentId: 'barbell',
            demoUrl: 'https://youtube.com/demo',
            bodyRegionId: 'upper_body',
            mechanics: 'compound',
          ),
        ],
      );

      when(
        () => mockLocalDataSource.getExercisesByIds(any()),
      ).thenAnswer((_) async => response);

      final result = await repository.getExercisesByIds(['ex-1']);

      expect(result.length, 1);
      expect(result.first.id, 'ex-1');
      expect(result.first.exercise, 'Bench Press');
      expect(result.first.difficultyLevel, 'intermediate');
      expect(result.first.targetMuscleGroup, 'chest');
      expect(result.first.primeMoverMuscle, 'pectoralis_major');
      expect(result.first.primaryEquipment, 'barbell');
      expect(
        result.first.shortYoutubeDemonstrationLink,
        'https://youtube.com/demo',
      );
      expect(result.first.bodyRegion, 'upper_body');
      expect(result.first.mechanics, 'compound');
      verify(() => mockLocalDataSource.getExercisesByIds(['ex-1'])).called(1);
    });

    test('getMealsByIds maps response to MealEntity list', () async {
      final response = MealsDatabaseResponse(
        meals: const [
          MealDatabaseDTO(
            id: 'meal-1',
            name: 'Steak',
            thumb: 'https://example.com/steak.jpg',
            areaId: 'American',
          ),
        ],
      );

      when(
        () => mockLocalDataSource.getMealsByIds(any()),
      ).thenAnswer((_) async => response);

      final result = await repository.getMealsByIds(['meal-1']);

      expect(result.length, 1);
      expect(result.first.id, 'meal-1');
      expect(result.first.name, 'Steak');
      expect(result.first.thumbnail, 'https://example.com/steak.jpg');
      expect(result.first.area, 'American');
      verify(() => mockLocalDataSource.getMealsByIds(['meal-1'])).called(1);
    });
  });
}
