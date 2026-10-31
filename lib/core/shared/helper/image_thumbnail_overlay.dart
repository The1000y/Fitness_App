import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitness_app/core/shared/helper/custom_button_click.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class ImageThumbnailOverlay extends StatelessWidget {
  const ImageThumbnailOverlay({
    super.key,
    required this.widget,
    required this.onPlayPressed,
    required this.thumbnailImage,
  });

  final Widget? widget;
  final String thumbnailImage;
  final VoidCallback onPlayPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: thumbnailImage,
          errorWidget: (context, url, error) {
            return Icon(Icons.error, color: AppColors.glow);
          },
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [AppColors.neutral[500]!, Colors.transparent],
            ),
          ),
        ),

        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: widget ?? const SizedBox.shrink(),
        ),

        Align(
          alignment: const Alignment(0, -0.35),
          child: CustomButtonClick(
            onPressed: onPlayPressed,
            iconWidget: Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 32.w,
            ),
          ),
        ),
      ],
    );
  }
}
