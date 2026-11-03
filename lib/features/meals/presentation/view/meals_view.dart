import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/core/constants/app_images.dart';
import 'package:fitness_app/core/shared/base_ui_event_listener.dart';
import 'package:fitness_app/core/shared/custom_app_bar.dart';
import 'package:fitness_app/core/shared/custom_background_image.dart';
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
    if (widget.activeCategory != null &&
        widget.activeCategory!.isNotEmpty &&
        cubit.state.selectedCategory != widget.activeCategory) {
      cubit.doEvent(ChangeSelectedMealCategoryEvent(widget.activeCategory!));
    }
  }

  @override
  void didUpdateWidget(covariant MealsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.activeCategory != oldWidget.activeCategory &&
        widget.activeCategory != null &&
        widget.activeCategory!.isNotEmpty) {
      context.read<MealsCubit>().doEvent(
        ChangeSelectedMealCategoryEvent(widget.activeCategory!),
      );
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
                : const Column(
                    children: [
                      MealsCategoriesBar(),
                      Expanded(child: MealsGridContent()),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
