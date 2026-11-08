import 'package:fitness_app/features/meals/presentation/view/widgets/shimmers/category_tab_bar_shimmer.dart';
import 'package:fitness_app/features/meals/presentation/view/widgets/shimmers/meals_grid_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

class MealsViewShimmer extends StatelessWidget {
  const MealsViewShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(16),
        const CategoryTabBarShimmer(),
        const Gap(16),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: const MealsGridShimmer(),
          ),
        ),
      ],
    );
  }
}
