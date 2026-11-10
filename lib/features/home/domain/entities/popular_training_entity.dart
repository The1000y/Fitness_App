import 'package:equatable/equatable.dart';

class PopularTrainingEntity extends Equatable {
  final String muscleId;
  final String muscleName;
  final String difficultyLevelId;
  final String difficultyLevelName;
  final int totalExercises;
  final String? muscleImage;
  const PopularTrainingEntity({
    required this.muscleId,
    required this.muscleName,
    required this.difficultyLevelId,
    required this.difficultyLevelName,
    required this.totalExercises,
    required this.muscleImage,
  });
  @override
  List<Object?> get props => [
    muscleId,
    muscleName,
    difficultyLevelId,
    difficultyLevelName,
    totalExercises,
    muscleImage,
  ];
}
