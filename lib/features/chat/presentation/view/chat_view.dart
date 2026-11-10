import 'package:fitness_app/core/constants/app_icons.dart';
import 'package:fitness_app/core/shared/custom_app_bar.dart';
import 'package:fitness_app/features/chat/presentation/view/widget/previous_conversations_drawer.dart';
// import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_images.dart';
import '../../../../core/shared/custom_background_image.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});
  final String name = "Ahmed";

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    // var l10n = AppLocalizations.of(context)!;
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
              Text('Hi $name , ', style: theme.textTheme.titleMedium),
              Text(
                'I am your smart coach',
                style: theme.textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
