import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../../../../config/base/base_cubit.dart';
import '../../../../../config/base/base_response.dart';
import '../../../../../config/base/base_state.dart';
import '../../../../../config/base/base_ui_event.dart';
import '../../../domain/use_cases/get_exercises_use_case.dart';
import 'exercise_details_event.dart';
import 'exercise_details_state.dart';

@injectable
class ExerciseDetailsCubit
    extends BaseCubit<ExerciseDetailsState, CommonUiEvent> {
  final GetExercisesUseCase _getExercisesUseCase;

  ExerciseDetailsCubit(this._getExercisesUseCase)
    : super(const ExerciseDetailsState());

  void onEvent(ExerciseDetailsEvent event) {
    switch (event) {
      case LoadExercises():
        if (!state.exercisesState.isLoading) {
          unawaited(_loadExercises(event));
        }
      case SelectExercise():
        final exercises = state.exercisesState.data?.exercises;
        final index = exercises == null || exercises.isEmpty
            ? event.index
            : event.index.clamp(0, exercises.length - 1);
        emit(state.copyWith(selectedIndex: index));
    }
  }

  Future<void> _loadExercises(LoadExercises event) async {
    if (state.exercisesState.isLoading) return;

    emit(state.copyWith(exercisesState: const BaseState(isLoading: true)));

    final result = await _getExercisesUseCase(
      primeMoverMuscleId: event.primeMoverMuscleId,
      difficultyLevelId: event.difficultyLevelId,
    );

    if (isClosed) return;

    switch (result) {
      case Success():
        emit(
          state.copyWith(
            exercisesState: BaseState(data: result.data, isLoading: false),
          ),
        );
      case Error():
        emit(
          state.copyWith(
            exercisesState: BaseState(
              isLoading: false,
              errorMessage: result.failure,
            ),
          ),
        );
        emitEvent(ShowFailureMessage(result.failure));
    }
  }
}
