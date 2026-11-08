import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/meals/presentation/manager/meals_state.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../helpers/test_data.dart';

void main() {
  group('MealsState', () {
    test('initial state has default idle BaseState', () {
      const state = MealsState();

      expect(state.mealsState.isLoading, isFalse);
      expect(state.mealsState.data, isNull);
      expect(state.mealsState.errorMessage, isNull);
    });

    test('copyWith without arguments preserves current mealsState', () {
      const state = MealsState(mealsState: BaseState(isLoading: true));

      final copy = state.copyWith();

      expect(copy.mealsState.isLoading, isTrue);
      expect(copy, equals(state));
    });

    test('copyWith with new mealsState updates state correctly', () {
      const state = MealsState();
      final newState = state.copyWith(
        mealsState: BaseState(
          data: [TestData.detailsMealEntity],
          isLoading: false,
        ),
      );

      expect(newState.mealsState.data?.length, 1);
      expect(newState.mealsState.isLoading, isFalse);
      expect(newState.mealsState.errorMessage, isNull);
      expect(newState, isNot(equals(state)));
    });

    test('can hold failure in mealsState', () {
      const failure = NotFoundFailure();
      final state = const MealsState().copyWith(
        mealsState: const BaseState(isLoading: false, errorMessage: failure),
      );

      expect(state.mealsState.errorMessage, equals(failure));
      expect(state.mealsState.isLoading, isFalse);
    });

    test('props equality works', () {
      const state1 = MealsState();
      const state2 = MealsState();

      expect(state1, equals(state2));
      expect(
        state1.props,
        equals([
          state1.mealsCategoriesState,
          state1.mealsByCategoriesState,
          state1.selectedCategory,
          state1.mealsState,
        ]),
      );
    });
  });
}
