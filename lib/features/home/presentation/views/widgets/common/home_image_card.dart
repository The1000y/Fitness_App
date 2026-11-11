import 'package:fitness_app/core/shared/custom_blur_card.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class HomeImageCard extends StatelessWidget {
  const HomeImageCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.size,
    required this.labelPadding,
    required this.onTap,
  });

  final String? imageUrl;
  final String title;
  final double size;
  final double labelPadding;
  final VoidCallback onTap;

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
              homeNetworkImage(imageUrl),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 30.h,
                child: CustomBlurCard(
                  borderRadius: BorderRadius.circular(20.r),
                  padding: EdgeInsets.symmetric(horizontal: labelPadding.w),
                  backgroundColor: AppColors.neutral.withValues(alpha: 0.5),
                  sigma: 10,
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

Widget homeNetworkImage(String? url, {Widget? onError}) {
  if (url == null || url.isEmpty) return _placeholder();
  return Image.network(
    url,
    fit: BoxFit.cover,
    errorBuilder: (_, _, _) => onError ?? _placeholder(),
  );
}

Widget _placeholder() {
  return ColoredBox(
    color: AppColors.surfaceMuted,
    child: Icon(
      Icons.image_not_supported_outlined,
      color: AppColors.textSecondary,
      size: 24.r,
    ),
  );
}
