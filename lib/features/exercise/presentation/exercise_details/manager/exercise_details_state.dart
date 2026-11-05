import 'package:equatable/equatable.dart';
import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/features/exercise/domain/entities/difficulty_level_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/exercises_list_entity.dart';

class ExerciseDetailsState extends Equatable {
  final BaseState<List<DifficultyLevelEntity>> levelsState;
  final int selectedLevelIndex;
  final BaseState<ExercisesListEntity> exercisesState;
  final int selectedIndex; // selected exercise (hero video)

  const ExerciseDetailsState({
    this.levelsState = const BaseState<List<DifficultyLevelEntity>>(),
    this.selectedLevelIndex = 0,
    this.exercisesState = const BaseState<ExercisesListEntity>(),
    this.selectedIndex = 0,
  });

  ExerciseDetailsState copyWith({
    BaseState<List<DifficultyLevelEntity>>? levelsState,
    int? selectedLevelIndex,
    BaseState<ExercisesListEntity>? exercisesState,
    int? selectedIndex,
  }) {
    return ExerciseDetailsState(
      levelsState: levelsState ?? this.levelsState,
      selectedLevelIndex: selectedLevelIndex ?? this.selectedLevelIndex,
      exercisesState: exercisesState ?? this.exercisesState,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  @override
  List<Object?> get props => [
    levelsState,
    selectedLevelIndex,
    exercisesState,
    selectedIndex,
  ];
}
