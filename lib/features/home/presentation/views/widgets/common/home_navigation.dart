import 'package:fitness_app/config/routing/app_routes.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/args/exercise_details_args.dart';
import 'package:flutter/material.dart';

void openExerciseDetails(
  BuildContext context, {
  required String muscleId,
  required String muscleName,
  String? difficultyLevelId,
}) {
  Navigator.pushNamed(
    context,
    AppRoutes.exerciseDetails,
    arguments: ExerciseDetailsArgs(
      primeMoverMuscleId: muscleId,
      muscleName: muscleName,
      difficultyLevelId: difficultyLevelId,
    ),
  );
}
