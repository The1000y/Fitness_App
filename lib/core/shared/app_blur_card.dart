import 'package:fitness_app/core/shared/app_blur_effect.dart';
import 'package:flutter/material.dart';

class AppBlurCard extends StatelessWidget {
  const AppBlurCard({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(30)),
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
    this.showWhiteBorders = false,
  });

  final Widget child;
  final bool showWhiteBorders;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: AppBlurEffect(
        child: Container(
          width: double.infinity,
          padding: padding,
          decoration: BoxDecoration(
            color: const Color(0x1A242424),
            borderRadius: borderRadius,
            border: showWhiteBorders == true
                ? Border.all(color: Colors.white.withValues(alpha: .15), width: 1,)
                : null,
          ),
          child: child,
        ),
      ),
    );
  }
}