import 'package:flutter/material.dart';

import '../../../../core/constants/app_images.dart';
import '../../../../core/shared/custom_background_image.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBackgroundImage(
      backgroundImage: AppImages.chatBackground,
      child: Scaffold(backgroundColor: Colors.transparent),
    );
  }
}
