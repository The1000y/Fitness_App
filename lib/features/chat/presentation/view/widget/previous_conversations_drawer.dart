import 'package:fitness_app/core/shared/custom_blur_card.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

class PreviousConversationsDrawer extends StatelessWidget {
  const PreviousConversationsDrawer({super.key, required this.onNewChat});

  final VoidCallback onNewChat;

  // بيانات تجريبية لحد ما تربطها بالـ Cubit
  static const _conversations = [
    'Lorem ipsum dolor sit amet',
    'Lorem ipsum dolor sit amet',
    'Lorem ipsum dolor sit amet',
    'Lorem ipsum dolor sit amet',
    'Lorem ipsum dolor sit amet',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = BorderRadius.horizontal(left: Radius.circular(24.r));
    final l10n = AppLocalizations.of(context)!;

    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.7,
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: radius),
      child: CustomBlurCard(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        borderRadius: radius,
        backgroundColor: AppColors.surface,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.previousConversations,
                    style: theme.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onNewChat();

                    },
                    icon: Icon(
                      Icons.add_circle_sharp,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const Gap(16),
              Expanded(
                child: ListView.separated(
                  itemCount: _conversations.length,
                  separatorBuilder: (_, _) => Divider(
                    height: 1,
                    color: AppColors.textSecondary.withValues(alpha: 0.3),
                  ),
                  itemBuilder: (context, index) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    leading: Icon(
                      Icons.chevron_left,
                      color: AppColors.primary,
                      size: 20.r,
                    ),
                    title: Text(
                      _conversations[index],
                      style: theme.textTheme.bodySmall,
                    ),
                    onTap: () {
                      Navigator.of(context).pop(); // يقفل الـ drawer
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
