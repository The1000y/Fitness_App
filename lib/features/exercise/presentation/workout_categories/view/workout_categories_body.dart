import 'package:fitness_app/core/shared/category_filter_widget.dart';
import 'package:fitness_app/core/shared/custom_app_bar.dart';
import 'package:fitness_app/core/shared/custom_background_image.dart';
import 'package:fitness_app/core/shared/image_title_card.dart';
import 'package:fitness_app/features/exercise/presentation/workout_categories/manager/workout_categories_cubit.dart';
import 'package:fitness_app/features/exercise/presentation/workout_categories/manager/workout_categories_event.dart';
import 'package:fitness_app/features/exercise/presentation/workout_categories/manager/workout_categories_state.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../core/constants/app_images.dart';

class WorkoutCategoriesBody extends StatefulWidget {
  const WorkoutCategoriesBody({super.key});

  @override
  State<WorkoutCategoriesBody> createState() =>
      _WorkoutCategoriesBodyState();
}

class _WorkoutCategoriesBodyState extends State<WorkoutCategoriesBody> {
  String selectedCategory = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<WorkoutCategoriesCubit, WorkoutCategoriesState>(
      listenWhen: (previous, current) {
        final groupsLoaded =
            previous.workoutCategoriesState.data == null &&
            current.workoutCategoriesState.data != null;

        final groupsError =
            previous.workoutCategoriesState.errorMessage !=
            current.workoutCategoriesState.errorMessage;

        final musclesError =
            previous.musclesState.errorMessage !=
            current.musclesState.errorMessage;

        return groupsLoaded || groupsError || musclesError;
      },
      listener: (context, state) {
        final groups = state.workoutCategoriesState.data?.musclesGroup;

        if (groups != null && groups.isNotEmpty) {
          final firstGroup = groups.first;

          setState(() {
            selectedCategory = firstGroup.name;
          });

          context.read<WorkoutCategoriesCubit>().onEvent(
                MusclesByGroupRequested(id: firstGroup.id),
              );
        }

        // عرض الأخطاء
        final errorMessage =
            state.workoutCategoriesState.errorMessage ??
            state.musclesState.errorMessage;

        if (errorMessage != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(errorMessage.toString()),
              ),
            );
        }
      },
      child: CustomBackgroundImage(
        backgroundImage: AppImages.authBackground,
        fit: BoxFit.cover,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(title: l10n.workouts),
          body: BlocBuilder<WorkoutCategoriesCubit, WorkoutCategoriesState>(
            builder: (context, state) {
              final groups =
                  state.workoutCategoriesState.data?.musclesGroup ?? [];

              final muscles =
                  state.musclesState.data?.muscles ?? [];

              return Column(
                children: [
                  SizedBox(height: 20.h),

                  // Muscle Groups
                  if (state.workoutCategoriesState.isLoading)
                    const LinearProgressIndicator(),

                  if (groups.isNotEmpty)
                    CategoryTabBar(
                      categories: groups.map((group) => group.name).toList(),
                      selectedCategory: selectedCategory,
                      onCategorySelected: (value) {
                        final selectedGroup = groups.firstWhere(
                          (group) => group.name == value,
                        );

                        setState(() {
                          selectedCategory = value;
                        });

                        context.read<WorkoutCategoriesCubit>().onEvent(
                              MusclesByGroupRequested(
                                id: selectedGroup.id,
                              ),
                            );
                      },
                    ),

                  SizedBox(height: 10.h),

                  // Muscles Grid
                  Expanded(
                    child: _buildMusclesGrid(
                      state: state,
                      muscles: muscles,
                      l10n: l10n,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMusclesGrid({
    required WorkoutCategoriesState state,
    required List muscles,
    required AppLocalizations l10n,
  }) {
    if (state.workoutCategoriesState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.workoutCategoriesState.data == null) {
      return Center(
        child: Text(l10n.noCategoriesAvailable),
      );
    }

    if (state.musclesState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.musclesState.data == null) {
      return Center(
        child: Text(l10n.selectCategory),
      );
    }

    if (muscles.isEmpty) {
      return Center(
        child: Text(l10n.noMusclesAvailable),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 12.h,
      ),
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
          onTap: () {
            // هنستخدمها لاحقاً عند فتح تفاصيل العضلة
          },
        );
      },
    );
  }
}