import 'package:fitness_app/core/shared/custom_button.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

Future<bool> showConfirmationDialog(
  BuildContext context, {
  required String message,
  Key? dialogKey,
  Key? noButtonKey,
  Key? yesButtonKey,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final result = await showDialog<bool>(
    context: context,
    barrierColor: AppColors.black.withValues(alpha: 0.50),
    builder: (dialogContext) {
      return Dialog(
        key: dialogKey,
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 26.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  height: 1.35,
                ),
              ),
              const Gap(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    key: noButtonKey,
                    label: l10n.no,
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                    variant: ButtonVariant.outlined,
                    width: 80.w,
                    height: 38.h,
                  ),
                  CustomButton(
                    key: yesButtonKey,
                    label: l10n.yes,
                    onPressed: () => Navigator.of(dialogContext).pop(true),
                    variant: ButtonVariant.filled,
                    enabled: true,
                    width: 80.w,
                    height: 38.h,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
  return result ?? false;
}
