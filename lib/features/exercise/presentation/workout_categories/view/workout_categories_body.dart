import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/config/routing/app_routes.dart';
import 'package:fitness_app/core/shared/base_ui_event_listener.dart';
import 'package:fitness_app/core/shared/category_filter_widget.dart';
import 'package:fitness_app/core/shared/custom_app_bar.dart';
import 'package:fitness_app/core/shared/custom_background_image.dart';
import 'package:fitness_app/core/shared/image_title_card.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscle_entity.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/args/exercise_details_args.dart';
import 'package:fitness_app/features/exercise/presentation/workout_categories/manager/workout_categories_cubit.dart';
import 'package:fitness_app/features/exercise/presentation/workout_categories/manager/workout_categories_state.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import 'package:fitness_app/core/constants/app_images.dart';

class WorkoutCategoriesBody extends StatelessWidget {
  const WorkoutCategoriesBody({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BaseUiEventListener<
      WorkoutCategoriesCubit,
      WorkoutCategoriesState,
      CommonUiEvent
    >(
      child: CustomBackgroundImage(
        backgroundImage: AppImages.authBackground,
        fit: BoxFit.cover,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(title: l10n.workouts),
          body: Column(
            children: [
              SizedBox(height: 20.h),

              BlocBuilder<WorkoutCategoriesCubit, WorkoutCategoriesState>(
                buildWhen: (previous, current) {
                  return previous.workoutCategoriesState !=
                          current.workoutCategoriesState ||
                      previous.selectedGroupId != current.selectedGroupId;
                },
                builder: (context, state) {
                  final groups =
                      state.workoutCategoriesState.data?.musclesGroup ?? [];

                  if (state.workoutCategoriesState.isLoading) {
                    return const LinearProgressIndicator();
                  }

                  if (groups.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return CategoryTabBar(
                    categories: groups.map((group) => group.name).toList(),
                    selectedCategory: state.selectedGroup!.name,
                    onCategorySelected: (value) {
                      context.read<WorkoutCategoriesCubit>().onCategorySelected(
                        value,
                      );
                    },
                  );
                },
              ),

              SizedBox(height: 10.h),

              // Muscles Grid
              const Expanded(child: WorkoutMusclesGrid()),
            ],
          ),
        ),
      ),
    );
  }
}

class WorkoutMusclesGrid extends StatelessWidget {
  const WorkoutMusclesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<WorkoutCategoriesCubit, WorkoutCategoriesState>(
      buildWhen: (previous, current) {
        return previous.workoutCategoriesState !=
                current.workoutCategoriesState ||
            previous.musclesState != current.musclesState ||
            previous.selectedGroupId != current.selectedGroupId;
      },
      builder: (context, state) {
        final muscles = state.musclesState.data?.muscles ?? <MuscleEntity>[];

        if (state.workoutCategoriesState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.workoutCategoriesState.data == null) {
          return Center(child: Text(l10n.noCategoriesAvailable));
        }

        if (state.workoutCategoriesState.data!.musclesGroup.isEmpty) {
          return Center(child: Text(l10n.noCategoriesAvailable));
        }

        if (state.musclesState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (muscles.isEmpty) {
          return Center(child: Text(l10n.noMusclesAvailable));
        }

        return GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 0.8,
          ),
          itemCount: muscles.length,
          itemBuilder: (context, index) {
            final muscle = muscles[index];

            return ImageTitleCard(
              imagePath: muscle.image,
              title: muscle.name,

              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.exerciseDetails,
                arguments: ExerciseDetailsArgs(
                  primeMoverMuscleId: muscle.id,
                  muscleName: muscle.name,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
