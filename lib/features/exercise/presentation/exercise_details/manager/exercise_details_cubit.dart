import 'dart:async';

import 'package:fitness_app/features/exercise/domain/use_cases/get_difficulty_levels_use_case.dart';
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
  final GetDifficultyLevelsUseCase _getLevelsUseCase;
  final GetExercisesUseCase _getExercisesUseCase;

  ExerciseDetailsCubit(this._getLevelsUseCase, this._getExercisesUseCase)
    : super(const ExerciseDetailsState());

  String _primeMoverMuscleId = '';

  String? get _selectedLevelId {
    final levels = state.levelsState.data;
    if (levels == null || levels.isEmpty) return null;
    return levels[state.selectedLevelIndex.clamp(0, levels.length - 1)].id;
  }

  void onEvent(ExerciseDetailsEvent event) {
    switch (event) {
      case LoadLevels():
        unawaited(_loadLevels(event));
      case SelectLevel():
        _selectLevel(event.index);
      case SelectExercise():
        final exercises = state.exercisesState.data?.exercises;
        final index = exercises == null || exercises.isEmpty
            ? event.index
            : event.index.clamp(0, exercises.length - 1);
        emit(state.copyWith(selectedIndex: index));
    }
  }

  Future<void> _loadLevels(LoadLevels event) async {
    _primeMoverMuscleId = event.primeMoverMuscleId;
    emit(state.copyWith(levelsState: const BaseState(isLoading: true)));

    final result = await _getLevelsUseCase(
      primeMoverMuscleId: _primeMoverMuscleId,
    );
    if (isClosed) return;

    switch (result) {
      case Success():
        final levels = result.data;
        emit(
          state.copyWith(
            levelsState: BaseState(data: levels),
            selectedLevelIndex: 0, // first level is the default
            selectedIndex: 0,
          ),
        );
        if (levels.isNotEmpty) await _loadExercises(levels.first.id);
      case Error():
        emit(
          state.copyWith(levelsState: BaseState(errorMessage: result.failure)),
        );
        emitEvent(ShowFailureMessage(result.failure));
    }
  }

  void _selectLevel(int index) {
    final levels = state.levelsState.data;
    if (levels == null || index < 0 || index >= levels.length) return;
    // allow tapping the same tab again only to retry after an error
    if (index == state.selectedLevelIndex &&
        state.exercisesState.errorMessage == null) {
      return;
    }
    emit(state.copyWith(selectedLevelIndex: index, selectedIndex: 0));
    unawaited(_loadExercises(levels[index].id));
  }

  Future<void> _loadExercises(String levelId) async {
    emit(state.copyWith(exercisesState: const BaseState(isLoading: true)));

    final result = await _getExercisesUseCase(
      primeMoverMuscleId: _primeMoverMuscleId,
      difficultyLevelId: levelId,
    );

    // ignore stale responses (user switched tab while this was loading)
    if (isClosed || _selectedLevelId != levelId) return;

    switch (result) {
      case Success():
        emit(state.copyWith(exercisesState: BaseState(data: result.data)));
      case Error():
        emit(
          state.copyWith(
            exercisesState: BaseState(errorMessage: result.failure),
          ),
        );
        emitEvent(ShowFailureMessage(result.failure));
    }
  }
}
