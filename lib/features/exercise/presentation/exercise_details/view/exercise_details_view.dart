import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/config/di/di.dart';
import 'package:fitness_app/core/shared/base_ui_event_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../manager/exercise_details_cubit.dart';
import '../manager/exercise_details_event.dart';
import '../manager/exercise_details_state.dart';
import 'exercise_details_body.dart';

class ExerciseDetailsView extends StatelessWidget {
  const ExerciseDetailsView({
    super.key,
    required this.primeMoverMuscleId,
    required this.difficultyLevelId,
    required this.muscleName,
  });

  final String primeMoverMuscleId;
  final String difficultyLevelId;
  final String muscleName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ExerciseDetailsCubit>()
        ..onEvent(
          LoadExercises(
            primeMoverMuscleId: primeMoverMuscleId,
            difficultyLevelId: difficultyLevelId,
          ),
        ),
      child: BaseUiEventListener<ExerciseDetailsCubit, ExerciseDetailsState,
          CommonUiEvent>(
        child: ExerciseDetailsBody(muscleName: muscleName),
      ),
    );
  }
}
