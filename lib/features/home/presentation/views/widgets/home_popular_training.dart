import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../core/theme/app_colors/app_colors.dart';
import '../../../../../l10n/app_localizations.dart';

class HomePopularTraining extends StatelessWidget {
  const HomePopularTraining ({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.popularTraining,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              height: 1.2,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 7.h),]);
  }
}