import 'package:fitness_app/config/di/di.dart';
import 'package:fitness_app/features/exercise/presentation/workout_categories/manager/workout_categories_cubit.dart';
import 'package:fitness_app/features/exercise/presentation/workout_categories/manager/workout_categories_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'workout_categories_body.dart';

class WorkoutCategoriesView extends StatelessWidget {
  const WorkoutCategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<WorkoutCategoriesCubit>()
        ..onEvent(const WorkoutCategoriesRequested()),
      child: const WorkoutCategoriesBody(),
    );
  }
}