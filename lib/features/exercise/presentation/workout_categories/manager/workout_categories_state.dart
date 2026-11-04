
import 'package:equatable/equatable.dart';
import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscle_groups_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscles_by_group_entity.dart';

class WorkoutCategoriesState extends Equatable {
  final BaseState<MuscleGroupsEntity> workoutCategoriesState;
  final BaseState<MusclesByGroupEntity> musclesState;
  final String? selectedGroupId;

  const WorkoutCategoriesState({
    this.workoutCategoriesState = const BaseState<MuscleGroupsEntity>(),
    this.musclesState = const BaseState<MusclesByGroupEntity>(),
    this.selectedGroupId,
  });

  // Getter for selected muscle group
  get selectedGroup {
    final groups = workoutCategoriesState.data?.musclesGroup ?? [];

    if (groups.isEmpty) return null;

    return groups.firstWhere(
      (group) => group.id == selectedGroupId,
      orElse: () => groups.first,
    );
  }

  WorkoutCategoriesState copyWith({
    BaseState<MuscleGroupsEntity>? workoutCategoriesState,
    BaseState<MusclesByGroupEntity>? musclesState,
    String? selectedGroupId,
  }) {
    return WorkoutCategoriesState(
      workoutCategoriesState:
          workoutCategoriesState ?? this.workoutCategoriesState,
      musclesState: musclesState ?? this.musclesState,
      selectedGroupId: selectedGroupId ?? this.selectedGroupId,
    );
  }

  @override
  List<Object?> get props => [
        workoutCategoriesState,
        musclesState,
        selectedGroupId,
      ];
}
