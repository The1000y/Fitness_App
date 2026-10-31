sealed class WorkoutCategoriesEvent {
  const WorkoutCategoriesEvent();
}

final class WorkoutCategoriesRequested extends WorkoutCategoriesEvent {
  const WorkoutCategoriesRequested();
}

final class MusclesByGroupRequested extends WorkoutCategoriesEvent {
  final String id;

  const MusclesByGroupRequested({
    required this.id,
  });
}