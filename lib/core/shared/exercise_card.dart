import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../theme/app_colors/app_colors.dart';
import 'app_blur_card.dart';

class ExerciseCard extends StatelessWidget {
  const ExerciseCard({
    super.key,
    required this.image,
    required this.title,
    this.size = 104,
    this.borderRadius = 30,
    this.padding,
    this.onTap,
  });

  final String image;
  final String title;
  final double size;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveRadius = BorderRadius.circular(borderRadius.r);
    final effectivePadding =
        padding ?? EdgeInsets.symmetric(vertical: 8.h, horizontal: 6.w);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.w,
        height: size.h,
        decoration: BoxDecoration(
          borderRadius: effectiveRadius,
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: AppBlurCard(
            padding: effectivePadding,
            borderRadius: effectiveRadius,
            child: Container(
              width: double.infinity,
              color: AppColors.surfaceGlass,
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ) ??
                    TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
