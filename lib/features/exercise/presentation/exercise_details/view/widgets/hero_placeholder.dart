import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:flutter/material.dart';

class HeroPlaceholder extends StatelessWidget {
  const HeroPlaceholder({super.key, required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 10,
      child: ColoredBox(
        color: AppColors.neutral.shade800,
        child: Stack(
          children: [
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            const Align(
              alignment: AlignmentDirectional.topStart,
              child: SafeArea(child: BackButton(color: AppColors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
