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
    final isNetwork =
        imagePath.startsWith('http://') || imagePath.startsWith('https://');

    return GestureDetector(
      onTap: onTap,
      child: isNetwork
          ? CachedNetworkImage(
              imageUrl: imagePath,
              imageBuilder: (context, imageProvider) =>
                  _buildCard(imageProvider),
              placeholder: (context, url) => _buildPlaceholder(),
              errorWidget: (context, url, error) => _buildErrorCard(),
            )
          : _buildCard(AssetImage(imagePath)),
    );
  }

  Widget _buildCard(ImageProvider imageProvider) {
    return Container(
      width: 170.w,
      height: 220.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            AppColors.black.withValues(alpha: 0.3),
            BlendMode.darken,
          ),
        ),
      ),
      child: _buildTitle(),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 170.w,
      height: 220.h,
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: _buildTitle(),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      width: 170.w,
      height: 220.h,
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Stack(
        children: [
          const Center(
            child: Icon(
              Icons.broken_image_outlined,
              color: AppColors.textSecondary,
            ),
          ),
          _buildTitle(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
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
    );
  }
}
