import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/manager/exercise_details_cubit.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/manager/exercise_details_event.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/manager/exercise_details_state.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/view/widgets/difficulty_tabs.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/view/widgets/exercise_empty_view.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/view/widgets/exercise_error_view.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/view/widgets/exercise_list_section.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/view/widgets/exercise_video_header_delegate.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/view/widgets/hero_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class ExerciseDetailsBody extends StatelessWidget {
  const ExerciseDetailsBody({super.key, required this.muscleName});

  final String muscleName;

  @override
  Widget build(BuildContext context) {
    final maxHeaderHeight = MediaQuery.sizeOf(context).width * 10 / 16;
    final minHeaderHeight = maxHeaderHeight * 0.55;

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
          if (levelsState.errorMessage != null) {
            return const ExerciseErrorView();
          }

          final levels = levelsState.data ?? [];
          if (levels.isEmpty) return const ExerciseEmptyView();

          final exercisesState = state.exercisesState;
          final exercises = exercisesState.data?.exercises ?? [];
          final selectedExercise = state.selectedExercise;
          final isReady = !exercisesState.isLoading;

          return NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent - 200) {
                context.read<ExerciseDetailsCubit>().onEvent(
                  const LoadMoreExercises(),
                );
              }
              return false;
            },
            child: CustomScrollView(
              slivers: [
                if (isReady && selectedExercise != null)
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: ExerciseVideoHeaderDelegate(
                      exercise: selectedExercise,
                      muscleName: muscleName,
                      autoPlay: state.autoPlay,
                      playRequestId: state.playRequestId,
                      maxHeight: maxHeaderHeight,
                      minHeight: minHeaderHeight,
                    ),
                  )
                else
                  SliverToBoxAdapter(
                    child: HeroPlaceholder(isLoading: exercisesState.isLoading),
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
                else if (isReady && exercises.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: ExerciseEmptyView(),
                  )
                else if (isReady && exercises.isNotEmpty)
                  ExerciseListSection(
                    muscleName: muscleName,
                    exercises: exercises,
                  ),
                if (state.isLoadingMore)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
