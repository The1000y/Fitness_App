import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class CustomButtonClick extends StatelessWidget {
  const CustomButtonClick({
    super.key,
    required this.onPressed,
    this.widthBackground = 60,
    this.hightBackground = 60,
    required this.iconWidget,
  });

  final VoidCallback onPressed;
  final double widthBackground;
  final double hightBackground;
  final Widget iconWidget;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: widthBackground.w,
        height: hightBackground.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.accent,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.5),
            width: 1.w,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.5),
              blurRadius: 25.r,
              spreadRadius: 3.r,
            ),
          ],
        ),
        child: iconWidget,
      ),
    );
  }
}