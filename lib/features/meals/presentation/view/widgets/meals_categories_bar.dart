import 'package:fitness_app/core/shared/category_filter_widget.dart';
import 'package:fitness_app/features/meals/presentation/manager/meals_cubit.dart';
import 'package:fitness_app/features/meals/presentation/manager/meals_event.dart';
import 'package:fitness_app/features/meals/presentation/manager/meals_state.dart';
import 'package:fitness_app/features/meals/presentation/view/widgets/custom_ui_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class MealsCategoriesBar extends StatelessWidget {
  const MealsCategoriesBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MealsCubit, MealsState>(
      buildWhen: (previous, current) =>
          previous.mealsCategoriesState != current.mealsCategoriesState ||
          previous.selectedCategory != current.selectedCategory,
      builder: (context, state) {
        final categoriesState = state.mealsCategoriesState;

        if (categoriesState.errorMessage != null) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: CategoriesErrorState(
              onRetry: () {
                context.read<MealsCubit>().doEvent(GetMealsCategoriesEvent());
              },
            ),
          );
        }

        final categories =
            categoriesState.data?.map((e) => e.name).toList() ?? [];

        if (categories.isEmpty || categoriesState.data == null) {
          return Padding(
            padding: REdgeInsets.symmetric(horizontal: 16),
            child: CategoriesEmptyState(
              onRefresh: () {
                context.read<MealsCubit>().doEvent(GetMealsCategoriesEvent());
              },
            ),
          );
        }

        return CategoryTabBar(
          categories: categories,
          selectedCategory: state.selectedCategory,
          onCategorySelected: (category) {
            context.read<MealsCubit>().doEvent(
              ChangeSelectedMealCategoryEvent(category),
            );
          },
        );
      },
    );
  }
}
