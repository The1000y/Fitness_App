import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoryTabBarShimmer extends StatelessWidget {
  const CategoryTabBarShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final widths = [85.w, 100.w, 75.w, 95.w, 80.w, 90.w];

    return Skeletonizer(
      enabled: true,
      effect: ShimmerEffect(
        baseColor: AppColors.borderSubtle,
        highlightColor: AppColors.surfaceMuted,
      ),
      child: SizedBox(
        height: 48.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: widths.length,
          separatorBuilder: (context, index) => Gap(10.w),
          itemBuilder: (context, index) {
            return Bone(
              width: widths[index],
              height: 48.h,
              borderRadius: BorderRadius.circular(24.r),
            );
          },
        ),
      ),
    );
  }
}
