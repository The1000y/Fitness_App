import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../theme/app_colors/app_colors.dart';

enum ButtonVariant { filled, outlined }

class CustomButton extends StatelessWidget {
  const CustomButton({
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
    final isFilled = variant == ButtonVariant.filled;

    final child = isLoading
        ? SizedBox(
            width: 22.r,
            height: 22.r,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: isFilled
                  ? AppColors.textPrimary
                  : theme.colorScheme.primary,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[icon!, SizedBox(width: 8.w)],
              Text(label),
            ],
          );

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 52.h,
      child: isFilled
          ? ElevatedButton(
              onPressed: _canPress ? onPressed : null,
              child: child,
            )
          : OutlinedButton(
              onPressed: _canPress ? onPressed : null,
              child: child,
            ),
    );
  }
}
