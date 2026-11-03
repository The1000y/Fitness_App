import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/exercise/domain/entities/exercises_list_entity.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/manager/exercise_details_state.dart';
import '../../../../../helpers/test_data.dart';

void main() {
  group('ExerciseDetailsState', () {
    test('has idle defaults', () {
      const state = ExerciseDetailsState();

      expect(state.selectedIndex, 0);
      expect(state.exercisesState.isLoading, false);
      expect(state.exercisesState.data, isNull);
      expect(state.exercisesState.errorMessage, isNull);
    });

    test('copyWith replaces the given values', () {
      const state = ExerciseDetailsState();

      final updated = state.copyWith(
        selectedIndex: 2,
        exercisesState: BaseState(data: TestData.exercisesListEntity),
      );

      expect(updated.selectedIndex, 2);
      expect(updated.exercisesState.data, TestData.exercisesListEntity);
      expect(state.selectedIndex, 0);
      expect(state.exercisesState.data, isNull);
    });

    test('copyWith keeps the previous values when nothing is passed', () {
      final state = ExerciseDetailsState(
        selectedIndex: 1,
        exercisesState: BaseState(
          isLoading: false,
          data: TestData.exercisesListEntity,
        ),
      );

      final copied = state.copyWith();

      expect(copied.selectedIndex, 1);
      expect(copied.exercisesState, state.exercisesState);
    });

    test('copyWith can store an error state', () {
      const state = ExerciseDetailsState();

      final failed = state.copyWith(
        exercisesState: const BaseState<ExercisesListEntity>(
          errorMessage: InternetConnectionFailure(),
        ),
      );

      expect(
        failed.exercisesState.errorMessage,
        isA<InternetConnectionFailure>(),
      );
      expect(failed.exercisesState.isLoading, false);
      expect(failed.exercisesState.data, isNull);
    });

    test('equality is value based', () {
      final first = ExerciseDetailsState(
        selectedIndex: 3,
        exercisesState: BaseState(data: TestData.exercisesListEntity),
      );
      final second = ExerciseDetailsState(
        selectedIndex: 3,
        exercisesState: BaseState(data: TestData.exercisesListEntity),
      );
      final different = first.copyWith(selectedIndex: 4);

      expect(first, second);
      expect(first, isNot(different));
      expect(first.props, contains(3));
    });
  });
}
