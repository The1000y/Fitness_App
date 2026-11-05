import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

class ExerciseErrorView extends StatelessWidget {
  const ExerciseErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: AppColors.primary, size: 48.r),
          Gap(16.h),
          Text(
            l10n.exerciseLoadFailed,
            style: TextStyle(color: AppColors.textPrimary, fontSize: 16.sp),
          ),
          Gap(12.h),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              l10n.goBack,
              style: TextStyle(color: AppColors.primary, fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }
}
