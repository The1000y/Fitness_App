import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_category_entity.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_entity.dart';
import 'package:fitness_app/features/meals/domain/use_cases/get_meals_by_category_use_case.dart';
import 'package:fitness_app/features/meals/domain/use_cases/get_meals_categories_use_case.dart';
import 'package:fitness_app/features/meals/presentation/manager/meals_cubit.dart';
import 'package:fitness_app/features/meals/presentation/manager/meals_event.dart';
import 'package:fitness_app/features/meals/presentation/manager/meals_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/meals_fakes.dart';
import '../../../../helpers/meals_test_data.dart';

void main() {
  late FakeMealsRepo fakeRepo;
  late GetMealsCategoriesUseCase getMealsCategoriesUseCase;
  late GetMealsByCategoryUseCase getMealsByCategoryUseCase;
  late MealsCubit cubit;

  setUp(() {
    fakeRepo = FakeMealsRepo();
    getMealsCategoriesUseCase = GetMealsCategoriesUseCase(fakeRepo);
    getMealsByCategoryUseCase = GetMealsByCategoryUseCase(fakeRepo);
    cubit = MealsCubit(getMealsCategoriesUseCase, getMealsByCategoryUseCase);
  });

  tearDown(() async {
    await cubit.close();
  });

  group('MealsCubit', () {
    test('initial state is const MealsState()', () {
      expect(cubit.state, const MealsState());
      expect(cubit.state.mealsCategoriesState.isLoading, isFalse);
      expect(cubit.state.mealsCategoriesState.data, isNull);
      expect(cubit.state.mealsByCategoriesState.isLoading, isFalse);
      expect(cubit.state.mealsByCategoriesState.data, isNull);
    });

    test(
      'GetMealsCategoriesEvent success emits loading true then false with categories data',
      () async {
        fakeRepo.nextCategoriesResult = Success(MealsTestData.categoryEntities);

        final states = <MealsState>[];
        final sub = cubit.stream.listen(states.add);
        addTearDown(sub.cancel);

        await cubit.doEvent(GetMealsCategoriesEvent());
        await pumpEventQueue();

        expect(states.length, 2);
        expect(states[0].mealsCategoriesState.isLoading, isTrue);
        expect(states[1].mealsCategoriesState.isLoading, isFalse);
        expect(
          states[1].mealsCategoriesState.data,
          MealsTestData.categoryEntities,
        );
      },
    );

    test(
      'GetMealsCategoriesEvent error emits loading true then false with errorMessage',
      () async {
        const failure = InternetConnectionFailure();
        fakeRepo.nextCategoriesResult = const Error<List<MealCategoryEntity>>(
          failure,
        );

        final states = <MealsState>[];
        final sub = cubit.stream.listen(states.add);
        addTearDown(sub.cancel);

        await cubit.doEvent(GetMealsCategoriesEvent());
        await pumpEventQueue();

        expect(states.length, 2);
        expect(states[0].mealsCategoriesState.isLoading, isTrue);
        expect(states[1].mealsCategoriesState.isLoading, isFalse);
        expect(states[1].mealsCategoriesState.errorMessage, failure);
      },
    );

    test(
      'GetMealsByCategoryEvent success emits loading true then false with meals data',
      () async {
        fakeRepo.nextMealsResult = Success(MealsTestData.mealEntities);

        final states = <MealsState>[];
        final sub = cubit.stream.listen(states.add);
        addTearDown(sub.cancel);

        await cubit.doEvent(GetMealsByCategoryEvent('Beef'));
        await pumpEventQueue();

        expect(fakeRepo.lastCategory, 'Beef');
        expect(states.length, 2);
        expect(states[0].mealsByCategoriesState.isLoading, isTrue);
        expect(states[1].mealsByCategoriesState.isLoading, isFalse);
        expect(
          states[1].mealsByCategoriesState.data,
          MealsTestData.mealEntities,
        );
      },
    );

    test(
      'GetMealsByCategoryEvent error emits loading true then false with errorMessage',
      () async {
        const failure = ServerFailure();
        fakeRepo.nextMealsResult = const Error<List<MealEntity>>(failure);

        final states = <MealsState>[];
        final sub = cubit.stream.listen(states.add);
        addTearDown(sub.cancel);

        await cubit.doEvent(GetMealsByCategoryEvent('Beef'));
        await pumpEventQueue();

        expect(states.length, 2);
        expect(states[0].mealsByCategoriesState.isLoading, isTrue);
        expect(states[1].mealsByCategoriesState.isLoading, isFalse);
        expect(states[1].mealsByCategoriesState.errorMessage, failure);
      },
    );

    test(
      'TriggerMealsAfterCategoriesCalledEvent fetches both categories and meals',
      () async {
        fakeRepo.nextCategoriesResult = Success(MealsTestData.categoryEntities);
        fakeRepo.nextMealsResult = Success(MealsTestData.mealEntities);

        await cubit.doEvent(TriggerMealsAfterCategoriesCalledEvent('Beef'));
        await pumpEventQueue();

        expect(fakeRepo.getCategoriesCallCount, 1);
        expect(fakeRepo.getMealsCallCount, 1);
        expect(fakeRepo.lastCategory, 'Beef');
        expect(
          cubit.state.mealsCategoriesState.data,
          MealsTestData.categoryEntities,
        );
        expect(
          cubit.state.mealsByCategoriesState.data,
          MealsTestData.mealEntities,
        );
      },
    );
  });
}
