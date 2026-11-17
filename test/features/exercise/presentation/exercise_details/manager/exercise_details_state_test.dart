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

      expect(state.levelsState.data, isNull);
      expect(state.selectedLevelIndex, 0);
      expect(state.selectedIndex, 0);
      expect(state.exercisesState.isLoading, false);
      expect(state.exercisesState.data, isNull);
      expect(state.exercisesState.errorMessage, isNull);
      expect(state.isLoadingMore, false);
      expect(state.autoPlay, false);
      expect(state.playRequestId, 0);
      expect(state.selectedExercise, isNull);
    });

    test('copyWith replaces the given values', () {
      const state = ExerciseDetailsState();

      final updated = state.copyWith(
        selectedIndex: 2,
        exercisesState: BaseState(data: TestData.exercisesListEntity),
        isLoadingMore: true,
        autoPlay: true,
        playRequestId: 3,
      );

      expect(updated.selectedIndex, 2);
      expect(updated.exercisesState.data, TestData.exercisesListEntity);
      expect(updated.isLoadingMore, true);
      expect(updated.autoPlay, true);
      expect(updated.playRequestId, 3);
      expect(state.selectedIndex, 0);
      expect(state.exercisesState.data, isNull);
      expect(state.isLoadingMore, false);
      expect(state.autoPlay, false);
      expect(state.playRequestId, 0);
    });

    test('selectedExercise follows the clamped selected index', () {
      final state = ExerciseDetailsState(
        exercisesState: BaseState(data: TestData.exercisesListEntity),
      );

      expect(state.selectedExercise?.exercise, 'Push Up');
      expect(
        state.copyWith(selectedIndex: 1).selectedExercise?.exercise,
        'Dumbbell Fly',
      );
      expect(
        state.copyWith(selectedIndex: 99).selectedExercise?.exercise,
        'Dumbbell Fly',
      );
      expect(
        state.copyWith(selectedIndex: -5).selectedExercise?.exercise,
        'Push Up',
      );
    });

    test('selectedExercise is null when there are no exercises', () {
      final state = ExerciseDetailsState(
        exercisesState: BaseState(
          data: const ExercisesListEntity(
            message: '',
            totalExercises: 0,
            totalPages: 0,
            currentPage: 0,
            exercises: [],
          ),
        ),
      );

      expect(state.selectedExercise, isNull);
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
