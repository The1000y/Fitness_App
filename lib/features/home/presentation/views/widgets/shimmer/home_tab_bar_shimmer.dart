import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeTabBarShimmer extends StatelessWidget {
  const HomeTabBarShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final widths = [85.w, 100.w, 75.w, 95.w, 80.w];

    return Skeletonizer(
      enabled: true,
      effect: ShimmerEffect(
        baseColor: AppColors.borderSubtle,
        highlightColor: AppColors.surfaceMuted,
      ),
      child: SizedBox(
        height: 30.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widths.length,
          separatorBuilder: (_, _) => SizedBox(width: 10.w),
          itemBuilder: (_, index) => Bone(
            width: widths[index],
            height: 30.h,
            borderRadius: BorderRadius.circular(24.r),
          ),
        ),
      ),
    );
  }
}
