import 'package:equatable/equatable.dart';
import 'package:fitness_app/config/base/base_state.dart';

import '../../../domain/entities/exercises_list_entity.dart';

class ExerciseDetailsState extends Equatable {
  final BaseState<ExercisesListEntity> exercisesState;

  const ExerciseDetailsState({
    this.exercisesState = const BaseState<ExercisesListEntity>(),
  });

  ExerciseDetailsState copyWith({
    BaseState<ExercisesListEntity>? exercisesState,
  }) {
    return ExerciseDetailsState(
      exercisesState: exercisesState ?? this.exercisesState,
    );
  }

  @override
  List<Object?> get props => [exercisesState];
}
