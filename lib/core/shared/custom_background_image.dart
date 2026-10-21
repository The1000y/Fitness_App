import 'package:flutter/material.dart';

import '../theme/app_colors/app_colors.dart';

class CustomBackgroundImage extends StatelessWidget {
  const CustomBackgroundImage({
    super.key,
    required this.backgroundImage,
    required this.child,
    this.showOverlay = true,
    this.overlayColor,
    this.fit = BoxFit.fill,
  });

  final String backgroundImage;
  final Widget child;
  final bool showOverlay;
  final Color? overlayColor;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            backgroundImage,
            fit: fit,
          ),
        ),
        if (showOverlay)
          Positioned.fill(
            child: ColoredBox(
              color: overlayColor ?? AppColors.overlay,
            ),
          ),
        child,
      ],
    );
  }
}
