import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../../../../config/base/base_cubit.dart';
import '../../../../../config/base/base_response.dart';
import '../../../../../config/base/base_state.dart';
import '../../../../../config/base/base_ui_event.dart';
import '../../../domain/use_cases/get_muscle_groups_use_case.dart';
import '../../../domain/use_cases/get_muscle_py_group_use_case .dart';
import 'workout_categories_event.dart';
import 'workout_categories_state.dart';

@injectable
class WorkoutCategoriesCubit
    extends BaseCubit<WorkoutCategoriesState, CommonUiEvent> {
  final GetMuscleGroupsUseCase _getMuscleGroupsUseCase;
  final GetMusclesByGroupUseCase _getMusclesByGroupUseCase;

  WorkoutCategoriesCubit(
    this._getMuscleGroupsUseCase,
    this._getMusclesByGroupUseCase,
  ) : super(const WorkoutCategoriesState());

  void onEvent(WorkoutCategoriesEvent event) {
    switch (event) {
      case WorkoutCategoriesRequested():
        unawaited(_getWorkoutCategories());

      case MusclesByGroupRequested():
        unawaited(_getMusclesByGroup(event.id));
    }
  }

  Future<void> _getWorkoutCategories() async {
    
    
    if (state.workoutCategoriesState.isLoading) return;

    emit(
      state.copyWith(
        workoutCategoriesState:
            const BaseState(isLoading: true),
      ),
    );

    final result = await _getMuscleGroupsUseCase();

    if (isClosed) return;

    switch (result) {
      case Success():
        emit(
          state.copyWith(
            workoutCategoriesState: BaseState(
              data: result.data,
              isLoading: false,
            ),
          ),
        );

      case Error():
        emit(
          state.copyWith(
            workoutCategoriesState: BaseState(
              isLoading: false,
              errorMessage: result.failure,
            ),
          ),
        );

        emitEvent(ShowFailureMessage(result.failure));
    }
  }

  Future<void> _getMusclesByGroup(String id) async {
    if (state.musclesState.isLoading) return;

    emit(
      state.copyWith(
        musclesState: const BaseState(isLoading: true),
      ),
    );

    final result = await _getMusclesByGroupUseCase(id: id);

    if (isClosed) return;

    switch (result) {
      case Success():
        emit(
          state.copyWith(
            musclesState: BaseState(
              data: result.data,
              isLoading: false,
            ),
          ),
        );

      case Error():
        emit(
          state.copyWith(
            musclesState: BaseState(
              isLoading: false,
              errorMessage: result.failure,
            ),
          ),
        );

        emitEvent(ShowFailureMessage(result.failure));
    }
  }
}