import 'package:fitness_app/core/constants/app_images.dart';
import 'package:fitness_app/core/shared/custom_background_image.dart';
import 'package:fitness_app/core/shared/custom_blur_card.dart';
import 'package:fitness_app/core/shared/custom_video_player.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/features/meals/presentation/view/widgets/data_of_ingredients.dart';
import 'package:fitness_app/features/meals/presentation/view/widgets/meal_info_overlay.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DetailsFoodView extends StatelessWidget {
  const DetailsFoodView({super.key, required this.mealId});

  final String mealId ; 

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return CustomBackgroundImage(
      backgroundImage: AppImages.layoutBackground,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomVideoPlayer(
              overlayContent: MealInfoOverlay(
                mealName: 'pasta with meat',
                mealDescription:
                    'Lorem ipsum dolor sit amet consectetur. Tempus volutpat ut nisi morbi. ',
                energyAmount: '100 k',
                protenAmount: '15 G',
                carbAmount: '58 G',
                fatAmount: '20 G',
              ),
              thumbnailImage:
                  "https://www.themealdb.com/images/media/meals/1548772327.jpg",
              videoUrl: "https://www.youtube.com/watch?v=xvPR2Tfw5k0",
            ),
            Gap(16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Ingredients', style: theme.textTheme.titleLarge),
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
                      return  Divider(
                        color: AppColors.neutral[300]!.withValues(alpha: 0.5),
                        // height: 1,
                      );
                    },
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      return DataOfIngredients(
                        strIngredient: 'Ingredient ${index + 1}',
                        strMeasure: '100 g',
                        theme: theme,
                      );
                    },
                    itemCount: 5,
                  
                  ),
                ),
              ),
            ),
            Gap(16),
          ],
        ),
      ),
    );
  }
}

