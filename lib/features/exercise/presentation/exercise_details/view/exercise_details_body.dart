import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/manager/exercise_details_cubit.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/manager/exercise_details_state.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/view/widgets/exercise_empty_view.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/view/widgets/exercise_error_view.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/view/widgets/exercise_list_section.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/view/widgets/hero_video_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExerciseDetailsBody extends StatelessWidget {
  const ExerciseDetailsBody({super.key, required this.muscleName});

  final String muscleName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<ExerciseDetailsCubit, ExerciseDetailsState>(
        builder: (context, state) {
          if (state.exercisesState.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state.exercisesState.errorMessage != null) {
            return const ExerciseErrorView();
          }

          final exercises = state.exercisesState.data?.exercises ?? [];
          if (exercises.isEmpty) return const ExerciseEmptyView();

          final selectedIndex = state.selectedIndex.clamp(
            0,
            exercises.length - 1,
          );
          final selected = exercises[selectedIndex];

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: HeroVideoSection(
                  key: ValueKey(
                    selected.id,
                  ), // new exercise -> new State -> new video
                  exercise: selected,
                  muscleName: muscleName,
                ),
              ),
              ExerciseListSection(muscleName: muscleName, exercises: exercises),
            ],
          );
        },
      ),
    );
  }
}
