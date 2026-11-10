import 'dart:async';

import 'package:fitness_app/config/base/base_cubit.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/features/exercise/domain/use_cases/get_muscle_groups_use_case.dart';
import 'package:fitness_app/features/exercise/domain/use_cases/get_muscles_by_group_use_case.dart';
import 'package:injectable/injectable.dart';

import '../../../auth/domain/use_cases/get_current_user_use_case.dart';
import '../../../exercise/domain/entities/muscle_entity.dart';
import '../../../exercise/domain/use_cases/get_random_muscles_use_case.dart';
import '../../../meals/domain/use_cases/get_meals_categories_use_case.dart';
import '../../domain/use_case/get_popular_training_use_case.dart';
import 'home_event.dart';
import 'home_state.dart';

@injectable
class HomeCubit extends BaseCubit<HomeState, CommonUiEvent> {
  final GetRandomMusclesUseCase _getRandomMuscles;
  final GetMuscleGroupsUseCase _getMuscleGroups;
  final GetMusclesByGroupUseCase _getMusclesByGroup;
  final GetMealsCategoriesUseCase _getMealCategories;
  final GetCurrentUserUseCase _getCurrentUser;
  final GetPopularTrainingUseCase _getPopularTraining;

  HomeCubit(
    this._getCurrentUser,
    this._getRandomMuscles,
    this._getMuscleGroups,
    this._getMusclesByGroup,
    this._getMealCategories,
    this._getPopularTraining,
  ) : super(const HomeState());

  void onEvent(HomeEvent event) {
    switch (event) {
      case HomeStarted():
        unawaited(_loadRandomMuscles());
        unawaited(_loadMuscleGroups());
        unawaited(_loadMealCategories());
        unawaited(_loadUser());
      case HomeRandomMusclesRetried():
        unawaited(_loadRandomMuscles());
      case HomeMuscleGroupsRetried():
        unawaited(_loadMuscleGroups());
      case HomeMealCategoriesRetried():
        unawaited(_loadMealCategories());
      case HomeMuscleGroupSelected():
        _selectGroup(event.groupId);
      case HomePopularTrainingRetried():
        final muscles = state.randomMusclesState.data?.muscles;
        if (muscles == null) {
          unawaited(_loadRandomMuscles());
        } else {
          unawaited(_loadPopularTraining(muscles));
        }
    }
  }

  Future<void> _loadUser() async {
    final result = await _getCurrentUser();
    if (isClosed) return;

    switch (result) {
      case Success():
        emit(state.copyWith(userState: BaseState(data: result.data)));
      case Error():
        emit(
          state.copyWith(userState: BaseState(errorMessage: result.failure)),
        );
    }
  }

  Future<void> _loadRandomMuscles() async {
    if (state.randomMusclesState.isLoading) return;

    emit(state.copyWith(randomMusclesState: const BaseState(isLoading: true)));

    final result = await _getRandomMuscles();
    if (isClosed) return;

    switch (result) {
      case Success():
        emit(state.copyWith(randomMusclesState: BaseState(data: result.data)));
        unawaited(_loadPopularTraining(result.data.muscles));
      case Error():
        emit(
          state.copyWith(
            randomMusclesState: BaseState(errorMessage: result.failure),
            popularTrainingState: BaseState(errorMessage: result.failure),
          ),
        );
    }
  }

  Future<void> _loadMealCategories() async {
    if (state.mealCategoriesState.isLoading) return;

    emit(state.copyWith(mealCategoriesState: const BaseState(isLoading: true)));

    final result = await _getMealCategories();
    if (isClosed) return;

    switch (result) {
      case Success():
        emit(state.copyWith(mealCategoriesState: BaseState(data: result.data)));
      case Error():
        emit(
          state.copyWith(
            mealCategoriesState: BaseState(errorMessage: result.failure),
          ),
        );
    }
  }

  Future<void> _loadMuscleGroups() async {
    if (state.muscleGroupsState.isLoading) return;

    emit(state.copyWith(muscleGroupsState: const BaseState(isLoading: true)));

    final result = await _getMuscleGroups();
    if (isClosed) return;

    switch (result) {
      case Success():
        final groups = result.data.musclesGroup;
        final firstId = groups.isEmpty ? null : groups.first.id;
        emit(
          state.copyWith(
            muscleGroupsState: BaseState(data: result.data),
            selectedGroupId: firstId,
          ),
        );
        if (firstId != null) unawaited(_loadGroupMuscles(firstId));
      case Error():
        emit(
          state.copyWith(
            muscleGroupsState: BaseState(errorMessage: result.failure),
          ),
        );
    }
  }

  void _selectGroup(String groupId) {
    if (state.selectedGroupId == groupId &&
        state.groupMusclesState.data != null) {
      return;
    }
    emit(state.copyWith(selectedGroupId: groupId));
    unawaited(_loadGroupMuscles(groupId));
  }

  Future<void> _loadGroupMuscles(String groupId) async {
    emit(state.copyWith(groupMusclesState: const BaseState(isLoading: true)));

    final result = await _getMusclesByGroup(id: groupId);
    if (isClosed) return;
    // The user tapped another tab while this request was in flight.
    if (state.selectedGroupId != groupId) return;

    switch (result) {
      case Success():
        emit(state.copyWith(groupMusclesState: BaseState(data: result.data)));
      case Error():
        emit(
          state.copyWith(
            groupMusclesState: BaseState(errorMessage: result.failure),
          ),
        );
    }
  }

  Future<void> _loadPopularTraining(List<MuscleEntity> muscles) async {
    if (state.popularTrainingState.isLoading) return;

    emit(
      state.copyWith(popularTrainingState: const BaseState(isLoading: true)),
    );

    final result = await _getPopularTraining(muscles: muscles);
    if (isClosed) return;

    switch (result) {
      case Success():
        emit(
          state.copyWith(popularTrainingState: BaseState(data: result.data)),
        );
      case Error():
        emit(
          state.copyWith(
            popularTrainingState: BaseState(errorMessage: result.failure),
          ),
        );
    }
  }
}
