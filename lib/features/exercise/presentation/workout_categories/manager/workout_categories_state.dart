import 'package:equatable/equatable.dart';
import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscles_by_group_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscles_entity.dart';

class WorkoutCategoriesState extends Equatable {
  final BaseState<MusclesByGroupEntity> workoutCategoriesState;

  final BaseState<MusclesEntity> musclesState;

  const WorkoutCategoriesState({
    this.workoutCategoriesState =
        const BaseState<MusclesByGroupEntity>(),
    this.musclesState = const BaseState<MusclesEntity>(),
  });

  WorkoutCategoriesState copyWith({
    BaseState<MusclesByGroupEntity>? workoutCategoriesState,
    BaseState<MusclesEntity>? musclesState,
  }) {
    return WorkoutCategoriesState(
      workoutCategoriesState:
          workoutCategoriesState ?? this.workoutCategoriesState,
      musclesState: musclesState ?? this.musclesState,
    );
  }

  @override
  List<Object?> get props => [
        workoutCategoriesState,
        musclesState,
      ];
}