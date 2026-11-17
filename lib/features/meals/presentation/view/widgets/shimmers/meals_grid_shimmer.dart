import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/features/meals/presentation/view/widgets/shimmers/meal_card_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MealsGridShimmer extends StatelessWidget {
  final int itemCount;

  const MealsGridShimmer({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      effect: ShimmerEffect(
        baseColor: AppColors.borderSubtle,
        highlightColor: AppColors.surfaceMuted,
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: 170 / 220,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) => const MealCardShimmer(),
      ),
    );
  }
}
