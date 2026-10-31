
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class InformationDataAboutMeals extends StatelessWidget {
  const InformationDataAboutMeals({
    super.key,
    required this.number,

    required this.title,
  });

  final String number;

  final String title;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      width: 54.w,
      height: 44.w,
      decoration: BoxDecoration(
        color: AppColors.neutral[500]!.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: 0.5.w, color: AppColors.white),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(number, style: theme.textTheme.labelSmall),
          Text(
            title,
            style: theme.textTheme.labelSmall!.copyWith(
              fontWeight: FontWeight(700),
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
