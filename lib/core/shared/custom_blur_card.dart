import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../theme/app_colors/app_colors.dart';
import 'custom_blur_effect.dart';

class CustomBlurCard extends StatelessWidget {
  const CustomBlurCard({
    super.key,
    required this.child,
    this.borderRadius,
    this.padding,
    this.showWhiteBorders = false,
    this.backgroundColor,
  });

  final Widget child;
  final bool showWhiteBorders;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius =
        borderRadius ?? BorderRadius.circular(30.r);
    final effectivePadding =
        padding ?? EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h);

    return ClipRRect(
      borderRadius: effectiveBorderRadius,
      child: CustomBlurEffect(
        child: Container(
          width: double.infinity,
          padding: effectivePadding,
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.surfaceGlass,
            borderRadius: effectiveBorderRadius,
            border: showWhiteBorders
                ? Border.all(
                    color: AppColors.white.withValues(alpha: 0.15),
                    width: 1.w,
                  )
                : null,
          ),
          child: child,
        ),
      ),
    );
  }
}
