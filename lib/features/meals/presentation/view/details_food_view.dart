import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/config/localization/app_failure_message_mapper.dart';
import 'package:fitness_app/core/constants/app_images.dart';
import 'package:fitness_app/core/shared/base_ui_event_listener.dart';
import 'package:fitness_app/core/shared/custom_background_image.dart';
import 'package:fitness_app/core/shared/custom_blur_card.dart';
import 'package:fitness_app/core/shared/custom_video_player.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/features/meals/presentation/manager/meals_cubit.dart';
import 'package:fitness_app/features/meals/presentation/manager/meals_state.dart';
import 'package:fitness_app/features/meals/presentation/view/widgets/data_of_ingredients.dart';
import 'package:fitness_app/features/meals/presentation/view/widgets/meal_info_overlay.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class DetailsFoodView extends StatelessWidget {
  const DetailsFoodView({super.key, required this.mealId});

  final String mealId;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var l10n = AppLocalizations.of(context)!;
    
    return BaseUiEventListener<MealsCubit, MealsState, BaseUiEvent>(
      child: CustomBackgroundImage(
        backgroundImage: AppImages.layoutBackground,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: BlocBuilder<MealsCubit, MealsState>(
            builder: (context, state) {
              var data = state.mealsState.data;
              if (state.mealsState.isLoading) {
                return Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              } else if (state.mealsState.errorMessage != null) {
                return Center(
                  child: Text(
                    appFailureMessageMapper(
                      state.mealsState.errorMessage!,
                      l10n,
                    ),
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                );
              } else if (state.mealsState.data == null ||
                  state.mealsState.data!.isEmpty) {
                return Center(
                  child: Text(
                    l10n.dataNotAvailable,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                );
              }

              final meal = data!.first;
              final ingredientList = meal.ingredients;
              debugPrint(meal.strYoutube);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  CustomVideoPlayer(
                    overlayContent: MealInfoOverlay(
                      mealName: meal.strMeal,
                      mealDescription: meal.strCategory,
                      //الارقام دي مش مبعوته في ال api ف انا كاتبها استاتيك متقوليش هاااارد كووووديددددد
                      energyAmount: '100 k',
                      protenAmount: '15 G',
                      carbAmount: '58 G',
                      fatAmount: '20 G',
                    ),
                    thumbnailImage: meal.strMealThumb,
                    videoUrl: meal.strYoutube,
                  ),
                  Gap(16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      l10n.ingredients,
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  Gap(12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: CustomBlurCard(
                        padding: const EdgeInsets.all(16),
                        showWhiteBorders: true,
                        child: ListView.separated(
                          separatorBuilder: (context, index) {
                            return Divider(
                              color: AppColors.neutral[300]!.withValues(
                                alpha: 0.5,
                              ),
                            );
                          },
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            final ingredient = ingredientList[index];
                            return DataOfIngredients(
                              strIngredient: ingredient.name,
                              strMeasure: ingredient.measure,
                              theme: theme,
                            );
                          },
                          itemCount: ingredientList.length,
                        ),
                      ),
                    ),
                  ),
                  Gap(16),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
