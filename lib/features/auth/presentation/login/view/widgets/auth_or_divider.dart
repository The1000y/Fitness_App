import 'package:fitness_app/core/constants/app_strings.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class AuthOrDivider extends StatelessWidget {
  const AuthOrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 36.w),
      child: Row(
        children: [
          const Expanded(child: Divider(color: AppColors.borderSubtle)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              AppStrings.or,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(color: AppColors.textSecondary),
            ),
          ),
          const Expanded(child: Divider(color: AppColors.borderSubtle)),
        ],
      ),
    );
  }
}
