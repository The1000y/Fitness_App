import 'package:equatable/equatable.dart';

import 'exercise_entity.dart';

class ExercisesListEntity extends Equatable {
  final String message;
  final int totalExercises;
  final int totalPages;
  final int currentPage;
  final List<ExerciseEntity> exercises;

  const ExercisesListEntity({
    required this.message,
    required this.totalExercises,
    required this.totalPages,
    required this.currentPage,
    required this.exercises,
  });

  @override
  List<Object?> get props => [
        message,
        totalExercises,
        totalPages,
        currentPage,
        exercises,
      ];
}
