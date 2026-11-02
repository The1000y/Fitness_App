import 'package:fitness_app/core/constants/app_images.dart';
import 'package:fitness_app/core/shared/category_filter_widget.dart';
import 'package:fitness_app/core/shared/custom_app_bar.dart';
import 'package:fitness_app/core/shared/custom_background_image.dart';
import 'package:fitness_app/core/shared/custom_ui_states.dart';
import 'package:fitness_app/core/shared/image_title_card.dart';
import 'package:fitness_app/features/meals/presentation/manager/meals_cubit.dart';
import 'package:fitness_app/features/meals/presentation/manager/meals_event.dart';
import 'package:fitness_app/features/meals/presentation/manager/meals_state.dart';
import 'package:fitness_app/features/meals/presentation/view/widgets/shimmers/shimmers.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

class MealsView extends StatefulWidget {
  final String? activeCategory;

  const MealsView({super.key, this.activeCategory});

  @override
  State<MealsView> createState() => _MealsViewState();
}

class _MealsViewState extends State<MealsView> {
  String? _selectedCategory;

  @override
  void initState() {
    _selectedCategory = widget.activeCategory;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CustomBackgroundImage(
      backgroundImage: AppImages.layoutBackground,
      child: Scaffold(
        appBar: CustomAppBar(title: l10n.foodRecommendation),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: BlocBuilder<MealsCubit, MealsState>(
            builder: (context, state) {
              final categoriesState = state.mealsCategoriesState;

              if (categoriesState.isLoading) {
                return const MealsViewShimmer();
              }

              if (categoriesState.errorMessage != null) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: CategoriesErrorState(
                    onRetry: () {
                      context.read<MealsCubit>().doEvent(
                        GetMealsCategoriesEvent(),
                      );
                    },
                  ),
                );
              }

              if (categoriesState.data == null) {
                return const MealsViewShimmer();
              }

              final List<String> categories =
                  categoriesState.data?.map((e) => e.name).toList() ?? [];

              if (categories.isEmpty) {
                return Padding(
                  padding: REdgeInsets.symmetric(horizontal: 16),
                  child: CategoriesEmptyState(
                    onRefresh: () {
                      context.read<MealsCubit>().doEvent(
                        GetMealsCategoriesEvent(),
                      );
                    },
                  ),
                );
              }

              final currentSelected =
                  (_selectedCategory != null &&
                      categories.contains(_selectedCategory))
                  ? _selectedCategory!
                  : categories.first;

              final mealsByCategoriesState = state.mealsByCategoriesState;

              if (mealsByCategoriesState.data == null &&
                  !mealsByCategoriesState.isLoading &&
                  mealsByCategoriesState.errorMessage == null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted &&
                      context
                              .read<MealsCubit>()
                              .state
                              .mealsByCategoriesState
                              .data ==
                          null &&
                      !context
                          .read<MealsCubit>()
                          .state
                          .mealsByCategoriesState
                          .isLoading &&
                      context
                              .read<MealsCubit>()
                              .state
                              .mealsByCategoriesState
                              .errorMessage ==
                          null) {
                    context.read<MealsCubit>().doEvent(
                      GetMealsByCategoryEvent(currentSelected),
                    );
                  }
                });
              }

              return Column(
                children: [
                  const Gap(16),
                  CategoryTabBar(
                    categories: categories,
                    selectedCategory: currentSelected,
                    onCategorySelected: (category) {
                      if (_selectedCategory != category) {
                        setState(() {
                          _selectedCategory = category;
                        });
                        context.read<MealsCubit>().doEvent(
                          GetMealsByCategoryEvent(category),
                        );
                      }
                    },
                  ),
                  const Gap(16),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Builder(
                        builder: (context) {
                          if (mealsByCategoriesState.isLoading) {
                            return const MealsGridShimmer();
                          }

                          if (mealsByCategoriesState.errorMessage != null) {
                            return MealsErrorState(
                              onRetry: () {
                                context.read<MealsCubit>().doEvent(
                                  GetMealsByCategoryEvent(currentSelected),
                                );
                              },
                            );
                          }

                          if (mealsByCategoriesState.data == null) {
                            return const MealsGridShimmer();
                          }

                          final meals = mealsByCategoriesState.data ?? [];

                          if (meals.isEmpty) {
                            return MealsEmptyState(
                              categoryLabel: currentSelected,
                              onRefresh: () {
                                context.read<MealsCubit>().doEvent(
                                  GetMealsByCategoryEvent(currentSelected),
                                );
                              },
                            );
                          }

                          return GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
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
}
