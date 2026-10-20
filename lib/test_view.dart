import 'package:fitness_app/core/constants/app_images.dart';
import 'package:fitness_app/core/shared/app_back_bar_bar.dart';
import 'package:fitness_app/core/shared/app_background_image.dart';
import 'package:fitness_app/core/shared/app_blur_card.dart';
import 'package:fitness_app/core/shared/app_button.dart';
import 'package:fitness_app/core/shared/exercise_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

import 'core/constants/app_icons.dart';
import 'core/theme/app_colors.dart';
import 'core/shared/app_text_form_field.dart';

class TestView extends StatelessWidget {
  const TestView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackgroundImage(
      backgroundImage: AppImages.layoutBackground,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBackAppBar(
         titleWidget: Image.asset(AppImages.robotChat),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.menu, color: AppColors.primary),
            ),
          ],
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                AppButton(label: 'Login', onPressed: () {}),

                const Gap(16),

                AppButton(
                  label: 'Back',
                  variant: ButtonVariant.outlined,
                  width: 100.w,
                  onPressed: () {},
                ),

                const Gap(16),

                AppBlurCard(
                  showWhiteBorders: true,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),

                      const Gap(8),

                      AppTextFormField(
                        hintText: 'Email',
                        prefixIcon: AppIcons.mail,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),

                      const SizedBox(height: 16),

                      AppTextFormField(
                        hintText: 'Password',
                        prefixIcon: AppIcons.lock,
                        isPassword: true,
                        textInputAction: TextInputAction.done,
                      ),

                      const Gap(16),

                      AppButton(
                        label: 'Login',
                        variant: ButtonVariant.outlined,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                const Gap(16),

                ExerciseCard(
                  image: AppImages.test(1),
                  title: 'Good',
                  borderRadius: 12,
                ),

                const Gap(16),

                ExerciseCard(
                  image: AppImages.test(1),
                  title: 'Good',
                  borderRadius: 12,
                ),

                const Gap(16),

                ExerciseCard(
                  image: AppImages.test(1),
                  title: 'Good',
                  borderRadius: 12,
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
