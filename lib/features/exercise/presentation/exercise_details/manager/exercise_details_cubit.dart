import 'dart:async';

import 'package:fitness_app/features/exercise/domain/entities/exercises_list_entity.dart';
import 'package:fitness_app/features/exercise/domain/use_cases/get_difficulty_levels_use_case.dart';
import 'package:injectable/injectable.dart';

import 'package:fitness_app/config/base/base_cubit.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/features/exercise/domain/use_cases/get_exercises_use_case.dart';
import 'exercise_details_event.dart';
import 'exercise_details_state.dart';

@injectable
class ExerciseDetailsCubit
    extends BaseCubit<ExerciseDetailsState, CommonUiEvent> {
  final GetDifficultyLevelsUseCase _getLevelsUseCase;
  final GetExercisesUseCase _getExercisesUseCase;

  static const int _pageSize = 10;

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
        _selectExercise(event);
      case LoadMoreExercises():
        unawaited(_loadMore());
    }
  }

  void _selectExercise(SelectExercise event) {
    final exercises = state.exercisesState.data?.exercises;
    if (exercises == null || exercises.isEmpty) return;

    final index = event.index.clamp(0, exercises.length - 1);
    emit(
      state.copyWith(
        selectedIndex: index,
        autoPlay: event.autoPlay,
        playRequestId: state.playRequestId + 1,
      ),
    );
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
        int initialIndex = 0;
        if (event.difficultyLevelId != null) {
          final foundIndex = levels.indexWhere(
            (l) => l.id == event.difficultyLevelId,
          );
          if (foundIndex != -1) {
            initialIndex = foundIndex;
          }
        }
        emit(
          state.copyWith(
            levelsState: BaseState(data: levels),
            selectedLevelIndex: initialIndex,
            selectedIndex: 0,
          ),
        );
        if (levels.isNotEmpty) await _loadExercises(levels[initialIndex].id);
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
    if (index == state.selectedLevelIndex &&
        state.exercisesState.errorMessage == null) {
      return;
    }
    emit(state.copyWith(selectedLevelIndex: index, selectedIndex: 0));
    unawaited(_loadExercises(levels[index].id));
  }

  Future<void> _loadExercises(String levelId) async {
    emit(
      state.copyWith(
        exercisesState: const BaseState(isLoading: true),
        isLoadingMore: false,
      ),
    );

    final result = await _getExercisesUseCase(
      primeMoverMuscleId: _primeMoverMuscleId,
      difficultyLevelId: levelId,
      page: 1,
      limit: _pageSize,
    );

    if (isClosed || _selectedLevelId != levelId) return;

    switch (result) {
      case Success():
        emit(
          state.copyWith(
            exercisesState: BaseState(data: result.data),
            selectedIndex: 0,
            autoPlay: false,
            isLoadingMore: false,
          ),
        );
      case Error():
        emit(
          state.copyWith(
            exercisesState: BaseState(errorMessage: result.failure),
            isLoadingMore: false,
          ),
        );
        emitEvent(ShowFailureMessage(result.failure));
    }
  }

  Future<void> _loadMore() async {
    final data = state.exercisesState.data;
    final levelId = _selectedLevelId;

    if (data == null ||
        levelId == null ||
        state.isLoadingMore ||
        state.exercisesState.isLoading ||
        !data.hasMore) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    final result = await _getExercisesUseCase(
      primeMoverMuscleId: _primeMoverMuscleId,
      difficultyLevelId: levelId,
      page: data.currentPage + 1,
      limit: _pageSize,
    );

    if (isClosed || _selectedLevelId != levelId) return;

    switch (result) {
      case Success():
        final current = state.exercisesState.data ?? data;
        final merged = ExercisesListEntity(
          message: result.data.message,
          totalExercises: result.data.totalExercises,
          totalPages: result.data.totalPages,
          currentPage: result.data.currentPage,
          exercises: [...current.exercises, ...result.data.exercises],
        );
        emit(
          state.copyWith(
            exercisesState: BaseState(data: merged),
            isLoadingMore: false,
          ),
        );
      case Error():
        emit(state.copyWith(isLoadingMore: false));
        emitEvent(ShowFailureMessage(result.failure));
    }
  }
}
