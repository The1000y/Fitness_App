import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:fitness_app/l10n/app_localizations.dart';

class EditFieldTile extends StatelessWidget {
  const EditFieldTile({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                '$label ',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            GestureDetector(
              onTap: onTap,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Text(
                  l10n.tapToEdit,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
        Gap(8.h),
        Container(
          width: double.infinity,
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          alignment: AlignmentDirectional.centerStart,
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(color: AppColors.white.withValues(alpha: 0.5)),
          ),
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              fontSize: 15.sp,
            ),
          ),
        ),
      ],
    );
  }
}
