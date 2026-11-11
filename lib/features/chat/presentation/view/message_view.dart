import 'package:fitness_app/config/di/di.dart';
import 'package:fitness_app/core/constants/app_icons.dart';
import 'package:fitness_app/core/constants/app_images.dart';
import 'package:fitness_app/core/shared/custom_app_bar.dart';
import 'package:fitness_app/core/shared/custom_background_image.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/features/chat/presentation/view/widget/custom_chat_message.dart';
import 'package:fitness_app/features/chat/presentation/view/widget/previous_conversations_drawer.dart';
import 'package:fitness_app/features/profile/presentation/manager/profile_cubit.dart';
import 'package:fitness_app/features/profile/presentation/manager/profile_state.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class MessageModel {
  final bool isUser;
  final String text;

  const MessageModel({required this.isUser, required this.text});
}

final messages = [
  MessageModel(isUser: true, text: 'Hello'),
  MessageModel(isUser: false, text: 'Hi! How can I help you today?'),
  MessageModel(
    isUser: true,
    text: 'I\'m learning Flutter and building a chat app.',
  ),
  MessageModel(
    isUser: false,
    text:
        'That\'s awesome! Are you using Bloc, Provider, or another state management solution?',
  ),
  MessageModel(isUser: true, text: 'I\'m using Bloc with Clean Architecture.'),
  MessageModel(
    isUser: false,
    text:
        'Great choice. It keeps your presentation, domain, and data layers well organized.',
  ),
  MessageModel(
    isUser: true,
    text: 'How can I keep the text field above the keyboard?',
  ),
  MessageModel(
    isUser: false,
    text:
        'You can place it inside the Scaffold\'s bottomNavigationBar or use SafeArea with viewInsets to move it above the keyboard.',
  ),
  MessageModel(isUser: true, text: 'Thanks! That solved my problem.'),
  MessageModel(
    isUser: false,
    text: 'You\'re welcome! Let me know if you need help with anything else.',
  ),
];

class MessageView extends StatefulWidget {
  const MessageView({super.key});

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var l10n = AppLocalizations.of(context)!;
    return CustomBackgroundImage(
      backgroundImage: AppImages.chatBackground,
      child: Scaffold(
        endDrawer: PreviousConversationsDrawer(
          onNewChat: () {
            setState(() {
              messages.clear();
            });
          },
        ),
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
        body: messages.isEmpty
            ? Center(child: Image.asset(AppImages.robotSkippingWithARope))
            : BlocBuilder<ProfileCubit, ProfileState>(
                bloc: getIt<ProfileCubit>(),
                builder: (context, state) {
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      var message = messages[index];
                      return CustomChatMessage(
                        text: message.text,
                        isSender: message.isUser,
                        senderAvatar: NetworkImage(
                          state.profileState.data!.photo,
                        ),
                        receiverAvatar: AssetImage(AppImages.robotChat),
                      );
                    },
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
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  color: AppColors.primary,
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
