import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:flutter/material.dart';

class CustomChatMessage extends StatelessWidget {
  const CustomChatMessage({
    super.key,
    required this.text,
    required this.isSender,
    required this.senderAvatar,
    required this.receiverAvatar,
  });

  final String text;
  final bool isSender;
  final ImageProvider senderAvatar;
  final ImageProvider receiverAvatar;

  @override
  Widget build(BuildContext context) {
    final avatar = Container(
      padding:  EdgeInsets.only(left: isSender? 0 : 16, right: isSender? 16 : 0),
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(
        color: AppColors.primary.withValues(alpha: 0.2),
        blurRadius: 10,
        spreadRadius: 1,
      ),
    ],
  ),
  child: CircleAvatar(
    radius: 22,
    backgroundColor: Colors.black,
    backgroundImage: isSender ? senderAvatar : receiverAvatar,
  ),
);

    final bubble = Flexible(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSender
                ? AppColors.accent.withValues(alpha: 0.5)
                : AppColors.neutral[500],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isSender ? 20 : 0),
              topRight: Radius.circular(isSender ? 0 : 20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ),
    );

    return Row(
      mainAxisAlignment: isSender
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (!isSender) avatar,
        const SizedBox(width: 8),
        bubble,
        const SizedBox(width: 8),
        if (isSender) avatar,
      ],
    );
  }
}
