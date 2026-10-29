import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../theme/app_colors/app_colors.dart';

class ImageTitleCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final VoidCallback onTap;

  const ImageTitleCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 170.w,
        height: 220.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              AppColors.black.withValues(alpha: 0.3),
              BlendMode.darken,
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.r),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
