import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/core/constants/app_images.dart';
import 'package:fitness_app/core/shared/base_ui_event_listener.dart';
import 'package:fitness_app/core/shared/custom_app_bar.dart';
import 'package:fitness_app/core/shared/custom_background_image.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_category_entity.dart';
import 'package:fitness_app/features/meals/presentation/manager/meals_cubit.dart';
import 'package:fitness_app/features/meals/presentation/manager/meals_event.dart';
import 'package:fitness_app/features/meals/presentation/manager/meals_state.dart';
import 'package:fitness_app/features/meals/presentation/view/widgets/meals_categories_bar.dart';
import 'package:fitness_app/features/meals/presentation/view/widgets/meals_grid_content.dart';
import 'package:fitness_app/features/meals/presentation/view/widgets/shimmers/shimmers.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MealsView extends StatefulWidget {
  final String? activeCategory;

  const MealsView({super.key, this.activeCategory});

  @override
  State<MealsView> createState() => _MealsViewState();
}

class _MealsViewState extends State<MealsView> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<MealsCubit>();
    final categoriesState = cubit.state.mealsCategoriesState;

    if (categoriesState.data == null && !categoriesState.isLoading) {
      cubit.doEvent(GetMealsCategoriesEvent(widget.activeCategory));
    } else if (categoriesState.data != null &&
        categoriesState.data!.isNotEmpty) {
      _initInitialCategory(cubit, categoriesState.data!);
    }
  }

  @override
  void didUpdateWidget(covariant MealsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.activeCategory != oldWidget.activeCategory &&
        widget.activeCategory != null) {
      final cubit = context.read<MealsCubit>();
      final categories = cubit.state.mealsCategoriesState.data;
      if (categories != null && categories.isNotEmpty) {
        _initInitialCategory(cubit, categories);
      }
    }
  }

  void _initInitialCategory(
    MealsCubit cubit,
    List<MealCategoryEntity> categories,
  ) {
    if (categories.isEmpty) return;
    final categoryNames = categories.map((e) => e.name).toList();
    final targetCategory =
        (widget.activeCategory != null &&
            categoryNames.contains(widget.activeCategory))
        ? widget.activeCategory!
        : (categoryNames.contains(cubit.state.selectedCategory)
              ? cubit.state.selectedCategory
              : categoryNames.first);

    if (cubit.state.selectedCategory != targetCategory) {
      cubit.doEvent(ChangeSelectedMealCategoryEvent(targetCategory));
    } else if (cubit.state.mealsByCategoriesState.data == null &&
        !cubit.state.mealsByCategoriesState.isLoading &&
        cubit.state.mealsByCategoriesState.errorMessage == null) {
      cubit.doEvent(GetMealsByCategoryEvent(targetCategory));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isCategoriesLoading = context.select<MealsCubit, bool>(
      (c) => c.state.mealsCategoriesState.isLoading,
    );

    return CustomBackgroundImage(
      backgroundImage: AppImages.layoutBackground,
      child: BaseUiEventListener<MealsCubit, MealsState, BaseUiEvent>(
        child: Scaffold(
          appBar: CustomAppBar(title: l10n.foodRecommendation),
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: isCategoriesLoading
                ? const MealsViewShimmer()
                : Column(
                    children: [
                      MealsCategoriesBar(
                        activeCategory: widget.activeCategory,
                        onNeedsCategoryInit: () {
                          if (mounted) {
                            final cubit = context.read<MealsCubit>();
                            final cats = cubit.state.mealsCategoriesState.data;
                            if (cats != null && cats.isNotEmpty) {
                              _initInitialCategory(cubit, cats);
                            }
                          }
                        },
                      ),
                      const Expanded(child: MealsGridContent()),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
