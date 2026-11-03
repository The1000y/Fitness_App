import 'package:equatable/equatable.dart';
import 'package:fitness_app/config/base/base_state.dart';

import '../../../domain/entities/exercises_list_entity.dart';

class ExerciseDetailsState extends Equatable {
  final BaseState<ExercisesListEntity> exercisesState;
  final int selectedIndex;

  const ExerciseDetailsState({
    this.exercisesState = const BaseState<ExercisesListEntity>(),
    this.selectedIndex = 0,
  });

  ExerciseDetailsState copyWith({
    BaseState<ExercisesListEntity>? exercisesState,
    int? selectedIndex,
  }) {
    return ExerciseDetailsState(
      exercisesState: exercisesState ?? this.exercisesState,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  @override
  List<Object?> get props => [exercisesState, selectedIndex];
}