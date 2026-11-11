class ExerciseDetailsArgs {
  final String primeMoverMuscleId;
  final String muscleName;
  final String? difficultyLevelId;

  const ExerciseDetailsArgs({
    required this.primeMoverMuscleId,
    required this.muscleName,
    this.difficultyLevelId,
  });
}
