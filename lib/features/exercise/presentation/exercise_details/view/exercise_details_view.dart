import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/core/shared/base_ui_event_listener.dart';
import 'package:flutter/material.dart';

import '../manager/exercise_details_cubit.dart';
import '../manager/exercise_details_state.dart';
import 'exercise_details_body.dart';

class ExerciseDetailsView extends StatelessWidget {
  const ExerciseDetailsView({super.key, required this.muscleName});

  final String muscleName;

  @override
  Widget build(BuildContext context) {
    return BaseUiEventListener<
      ExerciseDetailsCubit,
      ExerciseDetailsState,
      CommonUiEvent
    >(child: ExerciseDetailsBody(muscleName: muscleName));
  }
}
