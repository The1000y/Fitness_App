sealed class HomeEvent {
  const HomeEvent();
}

final class HomeStarted extends HomeEvent {
  const HomeStarted();
}

final class HomeRandomMusclesRetried extends HomeEvent {
  const HomeRandomMusclesRetried();
}

final class HomeMealCategoriesRetried extends HomeEvent {
  const HomeMealCategoriesRetried();
}

final class HomeMuscleGroupsRetried extends HomeEvent {
  const HomeMuscleGroupsRetried();
}

final class HomeMuscleGroupSelected extends HomeEvent {
  final String groupId;
  const HomeMuscleGroupSelected(this.groupId);
}

final class HomePopularTrainingRetried extends HomeEvent {
  const HomePopularTrainingRetried();
}
