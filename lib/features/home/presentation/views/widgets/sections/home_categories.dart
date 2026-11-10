import 'package:fitness_app/core/constants/app_images.dart';
import 'package:fitness_app/core/shared/custom_blur_card.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/common/home_section_title.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class HomeCategories extends StatelessWidget {
  const HomeCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final categories = [
      (image: 34, title: l10n.categoryGym),
      (image: 19, title: l10n.categoryFitness),
      (image: 25, title: l10n.categoryYoga),
      (image: 24, title: l10n.categoryAerobics),
      (image: 9, title: l10n.categoryTrainer),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionTitle(title: l10n.category),
        SizedBox(height: 7.h),
        SizedBox(
          width: 344.w,
          height: 90.h,
          child: CustomBlurCard(
            borderRadius: BorderRadius.circular(20.r),
            padding: EdgeInsets.symmetric(vertical: 8.h),
            backgroundColor: AppColors.neutral.withValues(alpha: 0.8),
            showWhiteBorders: false,
            sigma: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(categories.length, (index) {
                final category = categories[index];
                final isLast = index == categories.length - 1;
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
                          AppImages.avatar(category.image),
                          width: 40.r,
                          height: 40.r,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          category.title,
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