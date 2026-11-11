import 'package:fitness_app/core/constants/app_icons.dart';
import 'package:fitness_app/core/shared/custom_blur_card.dart';
import 'package:fitness_app/core/shared/helper/custom_button_click.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DetailsFoodShimmer extends StatelessWidget {
  const DetailsFoodShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final ingredientWidths = [120.w, 90.w, 140.w, 100.w, 130.w, 85.w];
    final measureWidths = [60.w, 45.w, 70.w, 50.w, 65.w, 40.w];

    return Skeletonizer(
      enabled: true,
      effect: ShimmerEffect(
        baseColor: AppColors.borderSubtle,
        highlightColor: AppColors.surfaceMuted,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20.r),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(color: AppColors.surfaceGlass),
                  Positioned(
                    top: 47,
                    left: 16,
                    child: Skeleton.keep(
                      child: CustomButtonClick(
                        heightBackground: 24,
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
                  Center(child: Bone.circle(size: 50.w)),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Bone(
                            width: 180.w,
                            height: 24.h,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          const Gap(6),
                          Bone(
                            width: 100.w,
                            height: 16.h,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          const Gap(20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              4,
                              (index) => Bone(
                                width: 54.w,
                                height: 44.w,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                            ),
                          ),
                          const Gap(10),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Gap(16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Bone(
              width: 110.w,
              height: 22.h,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          const Gap(12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomBlurCard(
                padding: const EdgeInsets.all(16),
                showWhiteBorders: true,
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: ingredientWidths.length,
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: AppColors.neutral[300]!.withValues(alpha: 0.5),
                    );
                  },
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Bone(
                            width: ingredientWidths[index],
                            height: 16.h,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          Bone(
                            width: measureWidths[index],
                            height: 16.h,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const Gap(16),
        ],
      ),
    );
  }
}

typedef DetailsFoodViewShimmer = DetailsFoodShimmer;
