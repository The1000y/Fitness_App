import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class CoachRecommendationCard extends StatelessWidget {
  const CoachRecommendationCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.badgeText,
    required this.icon,
    required this.onTap,
    this.imageUrl,
  });

  final String title;
  final String subtitle;
  final String badgeText;
  final IconData icon;
  final VoidCallback onTap;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 210.w,
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: AppColors.neutral[700]?.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.45)),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (hasImage)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl!,
                      width: 36.r,
                      height: 36.r,
                      fit: BoxFit.cover,
                      errorWidget: (_, _, _) => _buildIconBox(),
                    ),
                  )
                else
                  _buildIconBox(),
                SizedBox(width: 8.w),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.iconBubble,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      badgeText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11.sp,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12.r,
                  color: AppColors.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconBox() {
    return Container(
      width: 34.r,
      height: 34.r,
      decoration: BoxDecoration(
        color: AppColors.iconBubble,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(icon, color: AppColors.primary, size: 18.r),
    );
  }
}
