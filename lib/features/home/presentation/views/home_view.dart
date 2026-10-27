import 'package:fitness_app/core/constants/app_images.dart';
import 'package:fitness_app/core/shared/custom_background_image.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBackgroundImage(
      backgroundImage: AppImages.layoutBackground,
      child: Scaffold(backgroundColor: Colors.transparent),
    );
  }
}
