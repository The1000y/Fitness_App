sealed class ExerciseDetailsEvent {
  const ExerciseDetailsEvent();
}

final class LoadLevels extends ExerciseDetailsEvent {
  final String primeMoverMuscleId;
  const LoadLevels({required this.primeMoverMuscleId});
}

final class SelectLevel extends ExerciseDetailsEvent {
  final int index;
  const SelectLevel(this.index);
}

final class SelectExercise extends ExerciseDetailsEvent {
  final int index;
  final bool autoPlay;
  const SelectExercise(this.index, {this.autoPlay = false});
}

final class LoadMoreExercises extends ExerciseDetailsEvent {
  const LoadMoreExercises();
}
