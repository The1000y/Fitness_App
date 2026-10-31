import 'package:fitness_app/core/constants/app_icons.dart';
import 'package:fitness_app/core/constants/app_images.dart';
import 'package:fitness_app/core/shared/custom_background_image.dart';

import 'package:fitness_app/core/shared/custom_video_player.dart';
import 'package:fitness_app/core/shared/helper/custom_button_click.dart';
import 'package:fitness_app/core/shared/helper/meal_info_overlay.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TestView extends StatelessWidget {
  const TestView({super.key});

  final bool onBackTap = false;
  @override
  Widget build(BuildContext context) {
    // var theme = Theme.of(context);
    return CustomBackgroundImage(
      backgroundImage: AppImages.layoutBackground,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // appBar: CustomAppBar(),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  CustomVideoPlayer(
                    videoUrl: 'https://www.youtube.com/watch?v=xvPR2Tfw5k0',
                    mealInfoOverlay: MealInfoOverlay(
                      energyAmount: '200',
                      protenAmount: '10',
                      carbAmount: '30',
                      fatAmount: '200',
                      mealName: 'mealName',
                      mealDescription: 'mealDescription',
                    ),
                    thumbnailImage:
                        'https://www.themealdb.com/images/media/meals/1548772327.jpg',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 47),
                    child: Align(
                      alignment: const Alignment(-0.9, 0),
                      child: CustomButtonClick(
                        hightBackground: 24,
                        widthBackground: 24,
                        onPressed: () {
                          Navigator.maybePop(context);
                        },
                        iconWidget: SvgPicture.asset(
                          fit: BoxFit.scaleDown,
                          AppIcons.arrowBack,
                        ),
                      ),
                    ),
                  ),
                  // IconButton(
                  //     onPressed: onBackTap ? () => Navigator.maybePop(context): null,
                  //     style: IconButton.styleFrom(
                  //       backgroundColor: theme.colorScheme.primary,
                  //       shape: const CircleBorder(),
                  //       padding: EdgeInsets.zero,
                  //     ),
                  //     icon: SvgPicture.asset(
                  //       AppIcons.arrowBack,
                  //       height: 14.r,
                  //       width: 14.r,
                  //       colorFilter: const ColorFilter.mode(
                  //         AppColors.textPrimary,
                  //         BlendMode.srcIn,
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
