import 'package:flutter/material.dart';

import '../../../../core/constants/app_images.dart';
import '../../../../core/shared/custom_background_image.dart';

class WorkoutsView extends StatelessWidget {
  const WorkoutsView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBackgroundImage(
      backgroundImage: AppImages.layoutBackground,
      child: Scaffold(backgroundColor: Colors.transparent),
    );
  }
}
