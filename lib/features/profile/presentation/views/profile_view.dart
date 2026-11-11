import 'package:flutter/material.dart';

import 'package:fitness_app/core/constants/app_images.dart';
import 'package:fitness_app/core/shared/custom_background_image.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBackgroundImage(
      backgroundImage: AppImages.layoutBackground,
      child: Scaffold(backgroundColor: Colors.transparent),
    );
  }
}
