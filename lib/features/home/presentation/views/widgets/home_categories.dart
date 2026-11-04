import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../core/constants/app_images.dart';
import '../../../../../core/shared/custom_blur_card.dart';
import '../../../../../core/theme/app_colors/app_colors.dart';
import '../../../../../l10n/app_localizations.dart';

class HomeCategories extends StatelessWidget {
  const HomeCategories({super.key});

  static List<({int imageIndex, String Function(AppLocalizations) title})>
  _categories = [
    (imageIndex: 34, title: (l10n) => l10n.categoryGym),
    (imageIndex: 19, title: (l10n) => l10n.categoryFitness),
    (imageIndex: 25, title: (l10n) => l10n.categoryYoga),
    (imageIndex: 24, title: (l10n) => l10n.categoryAerobics),
    (imageIndex: 9, title: (l10n) => l10n.categoryTrainer),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.category,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            height: 1.2,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 7.h),
        SizedBox(
          width: 344.w,
          height: 90.h,
          child: CustomBlurCard(
            borderRadius: BorderRadius.circular(20.r),
            padding: EdgeInsets.symmetric(vertical: 8.h),
            backgroundColor: AppColors.neutral.withValues(alpha: 0.8),
            showWhiteBorders: false,
            blurSigma: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (index) {
                final isLast = index == 4;
                return InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(20.r),
                  child: Container(
                    width: 64.w,
                    height: 74.h,
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    decoration: BoxDecoration(
                      border: isLast
                          ? null
                          : BorderDirectional(
                              end: BorderSide(
                                color: AppColors.borderSubtle,
                                width: 1.w,
                              ),
                            ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppImages.avatar(_categories[index].imageIndex),
                          width: 40.r,
                          height: 40.r,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          _categories[index].title(l10n),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                height: 1.2,
                                color: AppColors.textPrimary,
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
