import 'package:cached_network_image/cached_network_image.dart';
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
    final imageUri = Uri.tryParse(imagePath);
    final isNetworkImage =
        imageUri != null &&
        (imageUri.scheme == 'http' || imageUri.scheme == 'https') &&
        imageUri.host.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 170.w,
        height: 170.h,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (isNetworkImage)
              CachedNetworkImage(
                imageUrl: imagePath,
                fit: BoxFit.cover,
                color: AppColors.black.withValues(alpha: 0.3),
                colorBlendMode: BlendMode.darken,
                placeholder: (context, url) =>
                    const ColoredBox(color: AppColors.surfaceMuted),
                errorWidget: (context, url, error) =>
                    const Center(child: Icon(Icons.broken_image_outlined)),
              )
            else
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
                color: AppColors.black.withValues(alpha: 0.3),
                colorBlendMode: BlendMode.darken,
                errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Icon(Icons.broken_image_outlined)),
              ),
            Padding(
              padding: EdgeInsets.all(1.r),
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
            
          ],
        ),
      ),
    );
  }
}
