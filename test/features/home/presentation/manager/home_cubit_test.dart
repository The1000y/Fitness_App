import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscle_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscle_group_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscle_groups_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscles_by_group_entity.dart';
import 'package:fitness_app/features/exercise/domain/use_cases/get_muscle_groups_use_case.dart';
import 'package:fitness_app/features/exercise/domain/use_cases/get_muscles_by_group_use_case.dart';
import 'package:fitness_app/features/exercise/domain/use_cases/get_random_muscles_use_case.dart';
import 'package:fitness_app/features/home/domain/entities/popular_training_entity.dart';
import 'package:fitness_app/features/home/domain/use_case/get_popular_training_use_case.dart';
import 'package:fitness_app/features/home/presentation/manager/home_cubit.dart';
import 'package:fitness_app/features/home/presentation/manager/home_event.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_category_entity.dart';
import 'package:fitness_app/features/meals/domain/use_cases/get_meals_categories_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetRandomMusclesUseCase extends Mock
    implements GetRandomMusclesUseCase {}

class MockGetMuscleGroupsUseCase extends Mock
    implements GetMuscleGroupsUseCase {}

class MockGetMusclesByGroupUseCase extends Mock
    implements GetMusclesByGroupUseCase {}

class MockGetMealsCategoriesUseCase extends Mock
    implements GetMealsCategoriesUseCase {}

class MockGetPopularTrainingUseCase extends Mock
    implements GetPopularTrainingUseCase {}

void main() {
  late MockGetRandomMusclesUseCase getRandomMuscles;
  late MockGetMuscleGroupsUseCase getMuscleGroups;
  late MockGetMusclesByGroupUseCase getMusclesByGroup;
  late MockGetMealsCategoriesUseCase getMealCategories;
  late MockGetPopularTrainingUseCase getPopularTraining;
  late HomeCubit cubit;

  const testMuscle = MuscleEntity(id: 'm-1', name: 'Chest', image: 'url');
  const randomMuscles = MusclesByGroupEntity(
    message: 'ok',
    totalMuscles: 1,
    muscles: [testMuscle],
  );
  const muscleGroups = MuscleGroupsEntity(
    message: 'ok',
    musclesGroup: [MuscleGroupEntity(id: 'g-1', name: 'Chest Group')],
  );
  const groupMuscles = MusclesByGroupEntity(
    message: 'ok',
    totalMuscles: 1,
    muscles: [testMuscle],
  );
  const mealCategories = <MealCategoryEntity>[
    MealCategoryEntity(
      id: 'cat-1',
      name: 'Breakfast',
      thumbnail: 'thumb',
      description: 'desc',
    ),
  ];
  const popularTrainings = <PopularTrainingEntity>[
    PopularTrainingEntity(
      muscleId: 'm-1',
      muscleName: 'Chest',
      difficultyLevelId: 'd-1',
      difficultyLevelName: 'Beginner',
      totalExercises: 5,
      muscleImage: 'img',
    ),
  ];

  setUp(() {
    getRandomMuscles = MockGetRandomMusclesUseCase();
    getMuscleGroups = MockGetMuscleGroupsUseCase();
    getMusclesByGroup = MockGetMusclesByGroupUseCase();
    getMealCategories = MockGetMealsCategoriesUseCase();
    getPopularTraining = MockGetPopularTrainingUseCase();

    cubit = HomeCubit(
      getRandomMuscles,
      getMuscleGroups,
      getMusclesByGroup,
      getMealCategories,
      getPopularTraining,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  group('HomeCubit', () {
    test('initial state is correct', () {
      expect(cubit.state.randomMusclesState.isLoading, isFalse);
      expect(cubit.state.muscleGroupsState.isLoading, isFalse);
      expect(cubit.state.mealCategoriesState.isLoading, isFalse);
      expect(cubit.state.popularTrainingState.isLoading, isFalse);
      expect(cubit.state.selectedGroupId, isNull);
    });

    test('HomeStarted loads random muscles, groups, meals, and popular training', () async {
      when(() => getRandomMuscles()).thenAnswer(
        (_) async => const Success(randomMuscles),
      );
      when(() => getMuscleGroups()).thenAnswer(
        (_) async => const Success(muscleGroups),
      );
      when(() => getMealCategories()).thenAnswer(
        (_) async => const Success(mealCategories),
      );
      when(() => getMusclesByGroup(id: 'g-1')).thenAnswer(
        (_) async => const Success(groupMuscles),
      );
      when(() => getPopularTraining(muscles: [testMuscle])).thenAnswer(
        (_) async => const Success(popularTrainings),
      );

      final randomLoaded = cubit.stream.firstWhere(
        (s) => s.randomMusclesState.data == randomMuscles,
      );
      final groupsLoaded = cubit.stream.firstWhere(
        (s) => s.muscleGroupsState.data == muscleGroups,
      );
      final mealsLoaded = cubit.stream.firstWhere(
        (s) => s.mealCategoriesState.data == mealCategories,
      );
      final popularLoaded = cubit.stream.firstWhere(
        (s) => s.popularTrainingState.data == popularTrainings,
      );

      cubit.onEvent(const HomeStarted());

      await Future.wait([randomLoaded, groupsLoaded, mealsLoaded, popularLoaded]);

      expect(cubit.state.randomMusclesState.data, randomMuscles);
      expect(cubit.state.muscleGroupsState.data, muscleGroups);
      expect(cubit.state.selectedGroupId, 'g-1');
      expect(cubit.state.mealCategoriesState.data, mealCategories);
      expect(cubit.state.popularTrainingState.data, popularTrainings);

      verify(() => getRandomMuscles()).called(1);
      verify(() => getMuscleGroups()).called(1);
      verify(() => getMealCategories()).called(1);
      verify(() => getMusclesByGroup(id: 'g-1')).called(1);
      verify(() => getPopularTraining(muscles: [testMuscle])).called(1);
    });

    test('HomeStarted handles error when random muscles request fails', () async {
      const failure = InternetConnectionFailure();
      when(() => getRandomMuscles()).thenAnswer((_) async => const Error(failure));
      when(() => getMuscleGroups()).thenAnswer((_) async => const Success(muscleGroups));
      when(() => getMealCategories()).thenAnswer((_) async => const Success(mealCategories));
      when(() => getMusclesByGroup(id: 'g-1')).thenAnswer((_) async => const Success(groupMuscles));

      final randomFailed = cubit.stream.firstWhere(
        (s) => s.randomMusclesState.errorMessage == failure,
      );

      cubit.onEvent(const HomeStarted());

      final state = await randomFailed;
      expect(state.randomMusclesState.errorMessage, failure);
      expect(state.popularTrainingState.errorMessage, failure);
    });

    test('HomeStarted handles error when meal categories request fails', () async {
      const failure = ServerFailure();
      when(() => getRandomMuscles()).thenAnswer((_) async => const Success(randomMuscles));
      when(() => getMuscleGroups()).thenAnswer((_) async => const Success(muscleGroups));
      when(() => getMealCategories()).thenAnswer((_) async => const Error(failure));
      when(() => getMusclesByGroup(id: 'g-1')).thenAnswer((_) async => const Success(groupMuscles));
      when(() => getPopularTraining(muscles: [testMuscle])).thenAnswer((_) async => const Success(popularTrainings));

      final mealsFailed = cubit.stream.firstWhere(
        (s) => s.mealCategoriesState.errorMessage == failure,
      );

      cubit.onEvent(const HomeStarted());

      final state = await mealsFailed;
      expect(state.mealCategoriesState.errorMessage, failure);
    });

    test('HomeStarted handles error when muscle groups request fails', () async {
      const failure = TimeoutFailure();
      when(() => getRandomMuscles()).thenAnswer((_) async => const Success(randomMuscles));
      when(() => getMuscleGroups()).thenAnswer((_) async => const Error(failure));
      when(() => getMealCategories()).thenAnswer((_) async => const Success(mealCategories));
      when(() => getPopularTraining(muscles: [testMuscle])).thenAnswer((_) async => const Success(popularTrainings));

      final groupsFailed = cubit.stream.firstWhere(
        (s) => s.muscleGroupsState.errorMessage == failure,
      );

      cubit.onEvent(const HomeStarted());

      final state = await groupsFailed;
      expect(state.muscleGroupsState.errorMessage, failure);
      verifyNever(() => getMusclesByGroup(id: any(named: 'id')));
    });

    test('HomeRandomMusclesRetried re-fetches random muscles', () async {
      when(() => getRandomMuscles()).thenAnswer((_) async => const Success(randomMuscles));
      when(() => getPopularTraining(muscles: [testMuscle])).thenAnswer((_) async => const Success(popularTrainings));

      final loaded = cubit.stream.firstWhere(
        (s) => s.randomMusclesState.data == randomMuscles,
      );

      cubit.onEvent(const HomeRandomMusclesRetried());

      await loaded;
      verify(() => getRandomMuscles()).called(1);
    });

    test('HomeMuscleGroupsRetried re-fetches muscle groups', () async {
      when(() => getMuscleGroups()).thenAnswer((_) async => const Success(muscleGroups));
      when(() => getMusclesByGroup(id: 'g-1')).thenAnswer((_) async => const Success(groupMuscles));

      final loaded = cubit.stream.firstWhere(
        (s) => s.muscleGroupsState.data == muscleGroups,
      );

      cubit.onEvent(const HomeMuscleGroupsRetried());

      await loaded;
      verify(() => getMuscleGroups()).called(1);
    });

    test('HomeMealCategoriesRetried re-fetches meal categories', () async {
      when(() => getMealCategories()).thenAnswer((_) async => const Success(mealCategories));

      final loaded = cubit.stream.firstWhere(
        (s) => s.mealCategoriesState.data == mealCategories,
      );

      cubit.onEvent(const HomeMealCategoriesRetried());

      await loaded;
      verify(() => getMealCategories()).called(1);
    });

    test('HomeMuscleGroupSelected fetches group muscles for new group id', () async {
      when(() => getMusclesByGroup(id: 'g-2')).thenAnswer((_) async => const Success(groupMuscles));

      final loaded = cubit.stream.firstWhere(
        (s) => s.selectedGroupId == 'g-2' && s.groupMusclesState.data == groupMuscles,
      );

      cubit.onEvent(const HomeMuscleGroupSelected('g-2'));

      final state = await loaded;
      expect(state.selectedGroupId, 'g-2');
      expect(state.groupMusclesState.data, groupMuscles);
      verify(() => getMusclesByGroup(id: 'g-2')).called(1);
    });

    test('HomeMuscleGroupSelected ignores selection if group is already selected with data', () async {
      when(() => getMusclesByGroup(id: 'g-1')).thenAnswer((_) async => const Success(groupMuscles));

      cubit.onEvent(const HomeMuscleGroupSelected('g-1'));
      await cubit.stream.firstWhere((s) => s.groupMusclesState.data != null);

      // Call again for same group
      cubit.onEvent(const HomeMuscleGroupSelected('g-1'));

      verify(() => getMusclesByGroup(id: 'g-1')).called(1);
    });

    test('HomePopularTrainingRetried uses existing random muscles if available', () async {
      when(() => getRandomMuscles()).thenAnswer((_) async => const Success(randomMuscles));
      when(() => getMuscleGroups()).thenAnswer((_) async => const Success(muscleGroups));
      when(() => getMealCategories()).thenAnswer((_) async => const Success(mealCategories));
      when(() => getMusclesByGroup(id: 'g-1')).thenAnswer((_) async => const Success(groupMuscles));
      when(() => getPopularTraining(muscles: [testMuscle])).thenAnswer((_) async => const Success(popularTrainings));

      cubit.onEvent(const HomeStarted());
      await cubit.stream.firstWhere((s) => s.popularTrainingState.data != null);

      cubit.onEvent(const HomePopularTrainingRetried());
      await cubit.stream.firstWhere((s) => s.popularTrainingState.data == popularTrainings);

      verify(() => getPopularTraining(muscles: [testMuscle])).called(2);
    });

    test('HomePopularTrainingRetried loads random muscles if data is null', () async {
      when(() => getRandomMuscles()).thenAnswer((_) async => const Success(randomMuscles));
      when(() => getPopularTraining(muscles: [testMuscle])).thenAnswer((_) async => const Success(popularTrainings));

      cubit.onEvent(const HomePopularTrainingRetried());
      await cubit.stream.firstWhere((s) => s.randomMusclesState.data == randomMuscles);

      verify(() => getRandomMuscles()).called(1);
    });
  });
}
