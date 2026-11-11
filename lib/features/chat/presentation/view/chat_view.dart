import 'package:flutter/material.dart';

import 'package:fitness_app/core/constants/app_images.dart';
import 'package:fitness_app/core/shared/custom_background_image.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBackgroundImage(
      backgroundImage: AppImages.chatBackground,
      child: const Scaffold(backgroundColor: Colors.transparent),
    );
  }
}
