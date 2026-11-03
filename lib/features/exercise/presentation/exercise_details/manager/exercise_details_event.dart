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
