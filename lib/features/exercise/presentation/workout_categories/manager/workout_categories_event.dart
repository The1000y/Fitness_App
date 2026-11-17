sealed class WorkoutCategoriesEvent {
  const WorkoutCategoriesEvent();
}

final class WorkoutCategoriesRequested extends WorkoutCategoriesEvent {
  const WorkoutCategoriesRequested();
}

final class MuscleGroupSelected extends WorkoutCategoriesEvent {
  final String id;

  const MuscleGroupSelected({required this.id});
}
