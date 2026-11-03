import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/meals/domain/entities/details_meal_entity.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_category_entity.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_entity.dart';
import 'package:fitness_app/features/meals/domain/use_cases/get_meal_details_use_case.dart';
import 'package:fitness_app/features/meals/domain/use_cases/get_meals_by_category_use_case.dart';
import 'package:fitness_app/features/meals/domain/use_cases/get_meals_categories_use_case.dart';
import 'package:fitness_app/features/meals/presentation/manager/meals_cubit.dart';
import 'package:fitness_app/features/meals/presentation/manager/meals_event.dart';
import 'package:fitness_app/features/meals/presentation/manager/meals_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fakes.dart';
import '../../../../helpers/meals_test_data.dart';
import '../../../../helpers/test_data.dart';

void main() {
  late FakeMealsRepo fakeRepo;
  late GetMealsCategoriesUseCase getMealsCategoriesUseCase;
  late GetMealsByCategoryUseCase getMealsByCategoryUseCase;
  late GetMealDetailsUseCase getMealDetailsUseCase;
  late MealsCubit cubit;

  setUp(() {
    fakeRepo = FakeMealsRepo();
    getMealsCategoriesUseCase = GetMealsCategoriesUseCase(fakeRepo);
    getMealsByCategoryUseCase = GetMealsByCategoryUseCase(fakeRepo);
    getMealDetailsUseCase = GetMealDetailsUseCase(fakeRepo);
    cubit = MealsCubit(
      getMealsCategoriesUseCase,
      getMealsByCategoryUseCase,
      getMealDetailsUseCase,
    );
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
      'GetMealsCategoriesEvent success emits loading true then false with categories data and fetches meals',
      () async {
        fakeRepo.nextCategoriesResult = Success(MealsTestData.categoryEntities);

        final states = <MealsState>[];
        final sub = cubit.stream.listen(states.add);
        addTearDown(sub.cancel);

        await cubit.doEvent(GetMealsCategoriesEvent());
        await pumpEventQueue();

        expect(states.length, 4);
        expect(states[0].mealsCategoriesState.isLoading, isTrue);
        expect(states[1].mealsCategoriesState.isLoading, isFalse);
        expect(
          states[1].mealsCategoriesState.data,
          MealsTestData.categoryEntities,
        );
        expect(states[1].selectedCategory, 'Beef');
        expect(states[2].mealsByCategoriesState.isLoading, isTrue);
        expect(states[3].mealsByCategoriesState.isLoading, isFalse);
      },
    );

    blocTest<MealsCubit, MealsState>(
      'successful GetMealDetailsEvent emits loading then success state',
      build: () {
        fakeRepo.nextResult = Success([TestData.detailsMealEntity]);
        return cubit;
      },
      act: (c) => c.onEvent(GetMealDetailsEvent(TestData.mealId)),
      expect: () => [
        const MealsState(
          mealsState: BaseState(
            data: null,
            isLoading: true,
            errorMessage: null,
          ),
        ),
        MealsState(
          mealsState: BaseState(
            data: [TestData.detailsMealEntity],
            isLoading: false,
            errorMessage: null,
          ),
        ),
      ],
      verify: (c) {
        expect(fakeRepo.callCount, 1);
        expect(fakeRepo.lastMealId, TestData.mealId);
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
      'failed GetMealDetailsEvent emits loading then error state and emits ShowFailureMessage event',
      () async {
        const failure = InternetConnectionFailure();
        fakeRepo.nextResult = const Error<List<DetailsMealEntity>>(
          failure,
        );

        final events = <BaseUiEvent>[];
        final subscription = cubit.uiEventStream.listen(events.add);

        final states = <MealsState>[];
        final stateSub = cubit.stream.listen(states.add);

        cubit.onEvent(GetMealDetailsEvent(TestData.mealId));

        await pumpEventQueue();

        expect(states, [
          const MealsState(
            mealsState: BaseState(
              data: null,
              isLoading: true,
              errorMessage: null,
            ),
          ),
          const MealsState(
            mealsState: BaseState(isLoading: false, errorMessage: failure),
          ),
        ]);

        expect(events.length, 1);
        expect(events.first, isA<ShowFailureMessage>());
        expect((events.first as ShowFailureMessage).failure, equals(failure));

        await subscription.cancel();
        await stateSub.cancel();
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
      'GetMealsCategoriesEvent with category fetches both categories and meals',
      () async {
        fakeRepo.nextCategoriesResult = Success(MealsTestData.categoryEntities);
        fakeRepo.nextMealsResult = Success(MealsTestData.mealEntities);

        await cubit.doEvent(GetMealsCategoriesEvent('Beef'));
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

    test(
      'GetMealsCategoriesEvent with unknown category falls back to first category',
      () async {
        fakeRepo.nextCategoriesResult = Success(MealsTestData.categoryEntities);
        fakeRepo.nextMealsResult = Success(MealsTestData.mealEntities);

        await cubit.doEvent(GetMealsCategoriesEvent('UnknownCategory'));
        await pumpEventQueue();

        expect(fakeRepo.lastCategory, 'Beef');
        expect(cubit.state.selectedCategory, 'Beef');
      },
    );

    test(
      'closing cubit while request is in flight emits nothing after close',
      () async {
        final completer = Completer<BaseResponse<List<DetailsMealEntity>>>();
        fakeRepo.completer = completer;

        final states = <MealsState>[];
        cubit.stream.listen(states.add);

        cubit.onEvent(GetMealDetailsEvent(TestData.mealId));
        await pumpEventQueue();
        expect(states.length, 1);
        expect(states.first.mealsState.isLoading, isTrue);

        await cubit.close();

        completer.complete(Success([TestData.detailsMealEntity]));
        await pumpEventQueue();

        // No new states emitted after closing
        expect(states.length, 1);
      },
    );
  });
}
