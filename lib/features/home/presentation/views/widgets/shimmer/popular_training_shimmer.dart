import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PopularTrainingShimmer extends StatelessWidget {
  final int itemCount;

  const PopularTrainingShimmer({super.key, this.itemCount = 3});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      effect: ShimmerEffect(
        baseColor: AppColors.borderSubtle,
        highlightColor: AppColors.surfaceMuted,
      ),
      child: SizedBox(
        height: 176.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: itemCount,
          separatorBuilder: (_, _) => SizedBox(width: 12.w),
          itemBuilder: (_, _) => const PopularTrainingCardShimmer(),
        ),
      ),
    );
  }
}

class PopularTrainingCardShimmer extends StatelessWidget {
  const PopularTrainingCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200.w,
      height: 176.h,
      child: Stack(
        children: [
          // Card background / image placeholder.
          Bone(
            width: 200.w,
            height: 176.h,
            borderRadius: BorderRadius.circular(20.r),
          ),
          // Heading placeholder (two lines).
          Positioned(
            top: 96.h,
            left: 0,
            right: 0,
            height: 34.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Block(width: 150.w, height: 12.h, radius: 6.r),
                SizedBox(height: 6.h),
                _Block(width: 100.w, height: 12.h, radius: 6.r),
              ],
            ),
          ),
          // Bottom pills placeholders.
          Positioned(
            top: 138.h,
            left: 16.w,
            right: 16.w,
            height: 30.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _Block(width: 60.w, height: 30.h, radius: 20.r),
                _Block(width: 65.w, height: 30.h, radius: 20.r),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({
    required this.width,
    required this.height,
    required this.radius,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Skeleton.keep(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.neutral.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
