import 'package:equatable/equatable.dart';
import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/features/exercise/domain/entities/difficulty_level_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/exercises_list_entity.dart';

class ExerciseDetailsState extends Equatable {
  final BaseState<List<DifficultyLevelEntity>> levelsState;
  final int selectedLevelIndex;
  final BaseState<ExercisesListEntity> exercisesState;
  final int selectedIndex;
  final bool isLoadingMore;
  final bool autoPlay;
  final int playRequestId;

  const ExerciseDetailsState({
    this.levelsState = const BaseState<List<DifficultyLevelEntity>>(),
    this.selectedLevelIndex = 0,
    this.exercisesState = const BaseState<ExercisesListEntity>(),
    this.selectedIndex = 0,
    this.isLoadingMore = false,
    this.autoPlay = false,
    this.playRequestId = 0,
  });

  ExerciseEntity? get selectedExercise {
    final exercises = exercisesState.data?.exercises;
    if (exercises == null || exercises.isEmpty) return null;
    return exercises[selectedIndex.clamp(0, exercises.length - 1)];
  }

  ExerciseDetailsState copyWith({
    BaseState<List<DifficultyLevelEntity>>? levelsState,
    int? selectedLevelIndex,
    BaseState<ExercisesListEntity>? exercisesState,
    int? selectedIndex,
    bool? isLoadingMore,
    bool? autoPlay,
    int? playRequestId,
  }) {
    return ExerciseDetailsState(
      levelsState: levelsState ?? this.levelsState,
      selectedLevelIndex: selectedLevelIndex ?? this.selectedLevelIndex,
      exercisesState: exercisesState ?? this.exercisesState,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      autoPlay: autoPlay ?? this.autoPlay,
      playRequestId: playRequestId ?? this.playRequestId,
    );
  }

  @override
  List<Object?> get props => [
    levelsState,
    selectedLevelIndex,
    exercisesState,
    selectedIndex,
    isLoadingMore,
    autoPlay,
    playRequestId,
  ];
}
