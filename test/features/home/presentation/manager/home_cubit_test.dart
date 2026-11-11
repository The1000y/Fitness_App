import 'package:fitness_app/features/exercise/domain/use_cases/get_muscle_groups_use_case.dart';
import 'package:fitness_app/features/exercise/domain/use_cases/get_muscles_by_group_use_case.dart';
import 'package:fitness_app/features/exercise/domain/use_cases/get_random_muscles_use_case.dart';
import 'package:fitness_app/features/home/domain/use_case/get_popular_training_use_case.dart';
import 'package:fitness_app/features/home/presentation/manager/home_cubit.dart';
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

  test('initial state is correct', () {
    expect(cubit.state.randomMusclesState.isLoading, isFalse);
    expect(cubit.state.muscleGroupsState.isLoading, isFalse);
  });
}
