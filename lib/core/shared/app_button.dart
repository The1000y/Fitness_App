import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../theme/app_colors/app_colors.dart';

enum ButtonVariant { filled, outlined }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = ButtonVariant.filled,
    this.isLoading = false,
    this.enabled = true,
    this.icon,
    this.width,
    this.height,
  });

  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final bool isLoading;
  final bool enabled;
  final Widget? icon;
  final double? width;
  final double? height;

  bool get _canPress => enabled && !isLoading && onPressed != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final isFilled = variant == ButtonVariant.filled;

    final child = isLoading
        ? SizedBox(
            width: 22.r,
            height: 22.r,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: isFilled ? AppColors.textPrimary : primaryColor,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                SizedBox(width: 8.w),
              ],
              Text(
                label,
                style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isFilled ? AppColors.textPrimary : primaryColor,
                    ) ??
                    TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isFilled ? AppColors.textPrimary : primaryColor,
                    ),
              ),
            ],
          );

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 52.h,
      child: isFilled
          ? ElevatedButton(
              onPressed: _canPress ? onPressed : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: AppColors.textPrimary,
                disabledBackgroundColor: primaryColor.withValues(alpha: 0.5),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24.w),
              ),
              child: child,
            )
          : OutlinedButton(
              onPressed: _canPress ? onPressed : null,
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryColor,
                side: BorderSide(
                  color: primaryColor.withValues(alpha: 0.8),
                  width: 1.5.w,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24.w),
              ),
              child: child,
            ),
    );
  }
}
