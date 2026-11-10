import 'package:fitness_app/config/routing/app_routes.dart';
import 'package:fitness_app/core/constants/app_icons.dart';
import 'package:fitness_app/core/shared/custom_app_bar.dart';
import 'package:fitness_app/core/shared/custom_blur_card.dart';
import 'package:fitness_app/core/shared/custom_button.dart';
import 'package:fitness_app/features/chat/presentation/view/widget/previous_conversations_drawer.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_images.dart';
import '../../../../core/shared/custom_background_image.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});
  final String name = "Ahmed";

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
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: Image.asset(AppImages.robotSkippingWithARope),
              ),
            ),
            // Spacer(),
            CustomBlurCard(
              borderRadius: BorderRadius.circular(50),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      l10n.chatHelpPrompt,
                      style: theme.textTheme.titleLarge,
                    ),
                    Gap(8),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: CustomButton(
                        label: l10n.getStarted,
                        width: 311.w,
                        height: 38.h,
                        enabled: true,
                        onPressed: () {
                       Navigator.of(context).pushNamed(AppRoutes.chatMessages);
                        },
                        variant: ButtonVariant.filled,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Gap(42),
          ],
        ),
      ),
    );
  }

}
