sealed class ExerciseDetailsEvent {
  const ExerciseDetailsEvent();
}

final class LoadExercises extends ExerciseDetailsEvent {
  final String primeMoverMuscleId;
  final String difficultyLevelId;

  const LoadExercises({
    required this.primeMoverMuscleId,
    required this.difficultyLevelId,
  });
}

final class SelectExercise extends ExerciseDetailsEvent {
  final int index;
  const SelectExercise(this.index);
}
