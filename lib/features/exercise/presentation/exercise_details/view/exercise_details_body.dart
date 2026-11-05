import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/manager/exercise_details_cubit.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/manager/exercise_details_event.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/manager/exercise_details_state.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/view/widgets/replace_ex.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/view/widgets/difficulty_tabs.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/view/widgets/exercise_empty_view.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/view/widgets/exercise_error_view.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/view/widgets/exercise_list_section.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/view/widgets/hero_video_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class ExerciseDetailsBody extends StatelessWidget {
  const ExerciseDetailsBody({super.key, required this.muscleName});

  final String muscleName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<ExerciseDetailsCubit, ExerciseDetailsState>(
        builder: (context, state) {
          final levelsState = state.levelsState;

          if (levelsState.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          if (levelsState.errorMessage != null)
            return const ExerciseErrorView();

          final levels = levelsState.data ?? [];
          if (levels.isEmpty) return const ExerciseEmptyView();

          final exercisesState = state.exercisesState;
          final exercises = exercisesState.data?.exercises ?? [];
          final hasExercises =
              !exercisesState.isLoading && exercises.isNotEmpty;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: hasExercises
                    ? HeroVideoSection(
                        key: ValueKey(
                          exercises[state.selectedIndex.clamp(
                                0,
                                exercises.length - 1,
                              )]
                              .id,
                        ),
                        exercise:
                            exercises[state.selectedIndex.clamp(
                              0,
                              exercises.length - 1,
                            )],
                        muscleName: muscleName,
                      )
                    : RePlaceholder(isLoading: exercisesState.isLoading),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 12.h),
                  child: DifficultyTabs(
                    levels: levels,
                    selectedIndex: state.selectedLevelIndex,
                    onSelected: (i) => context
                        .read<ExerciseDetailsCubit>()
                        .onEvent(SelectLevel(i)),
                  ),
                ),
              ),
              if (exercisesState.errorMessage != null)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: ExerciseErrorView(),
                )
              else if (!exercisesState.isLoading && exercises.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: ExerciseEmptyView(),
                )
              else if (hasExercises)
                ExerciseListSection(
                  muscleName: muscleName,
                  exercises: exercises,
                ),
            ],
          );
        },
      ),
    );
  }
}
