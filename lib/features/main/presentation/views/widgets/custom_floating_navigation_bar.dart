import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_test_keys.dart';
import '../../../../../core/shared/custom_blur_card.dart';
import '../../../../../core/theme/app_colors/app_colors.dart';
import '../../../../../l10n/app_localizations.dart';
import 'custom_tap_item.dart';

class CustomFloatingNavigationBar extends StatelessWidget {
  const CustomFloatingNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(right: 24.w, left: 24.w, bottom: 24.h),
        child: CustomBlurCard(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
          borderRadius: BorderRadius.circular(20.r),
          showWhiteBorders: true,
          backgroundColor: AppColors.surface,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: CustomTapItem(
                  key: const Key(AppTestKeys.mainTabExplore),
                  index: 0,
                  currentIndex: currentIndex,
                  iconPath: AppIcons.home,
                  label: l10n.explore,
                  onTap: onTap,
                ),
              ),
              Expanded(
                child: CustomTapItem(
                  key: const Key(AppTestKeys.mainTabCoach),
                  index: 1,
                  currentIndex: currentIndex,
                  iconPath: AppIcons.chatAi,
                  label: l10n.smartCoach,
                  onTap: onTap,
                ),
              ),
              Expanded(
                child: CustomTapItem(
                  key: const Key(AppTestKeys.mainTabWorkouts),
                  index: 2,
                  currentIndex: currentIndex,
                  iconPath: AppIcons.gym,
                  label: l10n.workouts,
                  onTap: onTap,
                ),
              ),
              Expanded(
                child: CustomTapItem(
                  key: const Key(AppTestKeys.mainTabProfile),
                  index: 3,
                  currentIndex: currentIndex,
                  iconPath: AppIcons.profile,
                  label: l10n.profile,
                  onTap: onTap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
