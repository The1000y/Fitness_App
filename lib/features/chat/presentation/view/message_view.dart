import 'package:fitness_app/core/constants/app_icons.dart';
import 'package:fitness_app/core/constants/app_images.dart';
import 'package:fitness_app/core/shared/custom_app_bar.dart';
import 'package:fitness_app/core/shared/custom_background_image.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/features/chat/presentation/view/widget/previous_conversations_drawer.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MessageView extends StatelessWidget {
  const MessageView({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var l10n = AppLocalizations.of(context)!;
    return CustomBackgroundImage(
      backgroundImage: AppImages.chatBackground,
      child: Scaffold(
        endDrawer: PreviousConversationsDrawer(),
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          actions: [
            Builder(
              builder: (context) {
                return IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: SvgPicture.asset(AppIcons.menu),
                );
              },
            ),
          ],
          titleWidget: Column(
            children: [
              Text(l10n.smartCoach, style: theme.textTheme.titleLarge),
            ],
          ),
        ),
        body: ListView.builder(
          itemCount: 22,
          itemBuilder: (context, index) {
            return ChatMessage(
              text:
                  'Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello ',
              isSender: true,
              senderAvatar: AssetImage(AppImages.senderBackground ),
              receiverAvatar: AssetImage(AppImages.robotChat),
            );
          },
        ),

        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            left: 8,
            right: 8,
            top: 8,
            bottom: MediaQuery.of(context).viewInsets.bottom + 8,
          ),
          child: SafeArea(
            child: TextField(
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              decoration: InputDecoration(
                hintText: l10n.typeYourMessage,
                hintStyle: theme.textTheme.bodyMedium!.copyWith(
                  color: AppColors.textMuted,
                ),
                filled: true,
                fillColor: AppColors.surfaceMuted,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: const Icon(Icons.send, color: AppColors.primary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  const ChatMessage({
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
          child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
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
