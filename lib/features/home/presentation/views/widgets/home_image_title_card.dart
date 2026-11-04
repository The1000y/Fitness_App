
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../core/shared/custom_blur_card.dart';
import '../../../../../core/theme/app_colors/app_colors.dart';

class HomeImageTitleCard extends StatelessWidget {
  const HomeImageTitleCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.size,
    required this.labelHeight,
    required this.labelPadding,
    this.labelBorderRadius,
    this.onTap,
  });

  final String? imageUrl;
  final String title;
  final double size;
  final double labelHeight;
  final EdgeInsetsGeometry labelPadding;
  final BorderRadius? labelBorderRadius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: size.w,
          height: size.h,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (imageUrl != null && imageUrl!.isNotEmpty)
                Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox.expand();
                  },
                )
              else
                const _ImagePlaceholder(),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: labelHeight.h,
                child: CustomBlurCard(
                  borderRadius:
                  labelBorderRadius ?? BorderRadius.circular(20.r),
                  padding: labelPadding,
                  backgroundColor: AppColors.neutral.withValues(alpha: 0.5),
                  blurSigma: 10,
                  child: Center(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surfaceMuted,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: AppColors.textSecondary,
        size: 24.r,
      ),
    );
  }
}
