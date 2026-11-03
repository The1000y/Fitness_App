import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/core/shared/image_title_card.dart';
import 'package:fitness_app/features/meals/presentation/manager/meals_cubit.dart';
import 'package:fitness_app/features/meals/presentation/manager/meals_event.dart';
import 'package:fitness_app/features/meals/presentation/manager/meals_state.dart';
import 'package:fitness_app/features/meals/presentation/view/widgets/custom_ui_states.dart';
import 'package:fitness_app/features/meals/presentation/view/widgets/shimmers/meals_grid_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class MealsGridContent extends StatelessWidget {
  const MealsGridContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MealsCubit, MealsState>(
      buildWhen: (previous, current) =>
          previous.mealsByCategoriesState != current.mealsByCategoriesState ||
          previous.selectedCategory != current.selectedCategory ||
          previous.mealsCategoriesState != current.mealsCategoriesState,
      builder: (context, state) {
        if (state.mealsCategoriesState.errorMessage != null ||
            (state.mealsCategoriesState.data?.isEmpty ?? false)) {
          return const SizedBox.shrink();
        }

        final mealsByCategoriesState = state.mealsByCategoriesState;

        return Padding(
          padding: EdgeInsets.all(16.w),
          child: Builder(
            builder: (context) {
              if (mealsByCategoriesState.isLoading) {
                return const MealsGridShimmer();
              }

              if (mealsByCategoriesState.errorMessage != null) {
                return MealsErrorState(
                  isOffline:
                      mealsByCategoriesState.errorMessage
                          is InternetConnectionFailure,
                  onRetry: () {
                    context.read<MealsCubit>().doEvent(
                      GetMealsByCategoryEvent(state.selectedCategory),
                    );
                  },
                );
              }

              final meals = mealsByCategoriesState.data ?? [];

              if (meals.isEmpty || mealsByCategoriesState.data == null) {
                return MealsEmptyState(
                  categoryLabel: state.selectedCategory,
                  onRefresh: () {
                    context.read<MealsCubit>().doEvent(
                      GetMealsByCategoryEvent(state.selectedCategory),
                    );
                  },
                );
              }

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 16.h,
                  childAspectRatio: 170 / 220,
                ),
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  final meal = meals[index];
                  return ImageTitleCard(
                    imagePath: meal.thumbnail,
                    title: meal.name,
                    onTap: () {
                      // Action on tapping a meal card
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
