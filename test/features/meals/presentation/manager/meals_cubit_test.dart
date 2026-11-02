import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/meals/domain/entities/details_meal_entity.dart';
import 'package:fitness_app/features/meals/domain/use_cases/get_meal_details_use_case.dart';
import 'package:fitness_app/features/meals/presentation/manager/meals_cubit.dart';
import 'package:fitness_app/features/meals/presentation/manager/meals_event.dart';
import 'package:fitness_app/features/meals/presentation/manager/meals_state.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../helpers/fakes.dart';
import '../../../../helpers/test_data.dart';

void main() {
  late FakeMealsRepo fakeMealsRepo;
  late GetMealDetailsUseCase useCase;
  late MealsCubit cubit;

  setUp(() {
    fakeMealsRepo = FakeMealsRepo();
    useCase = GetMealDetailsUseCase(fakeMealsRepo);
    cubit = MealsCubit(useCase);
  });

  tearDown(() async {
    await cubit.close();
  });

  group('MealsCubit', () {
    test('initial state is MealsState()', () {
      expect(cubit.state, const MealsState());
    });

    blocTest<MealsCubit, MealsState>(
      'successful GetMealDetailsEvent emits loading then success state',
      build: () {
        fakeMealsRepo.nextResult = Success([TestData.detailsMealEntity]);
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
        expect(fakeMealsRepo.callCount, 1);
        expect(fakeMealsRepo.lastMealId, TestData.mealId);
      },
    );

    test(
      'failed GetMealDetailsEvent emits loading then error state and emits ShowFailureMessage event',
      () async {
        const failure = InternetConnectionFailure();
        fakeMealsRepo.nextResult = const Error<List<DetailsMealEntity>>(
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
      'closing cubit while request is in flight emits nothing after close',
      () async {
        final completer = Completer<BaseResponse<List<DetailsMealEntity>>>();
        fakeMealsRepo.completer = completer;

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
