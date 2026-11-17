import 'dart:io';

import 'package:fitness_app/core/shared/custom_blur_card.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/features/chat/presentation/manager/chat_cubit.dart';
import 'package:fitness_app/features/chat/presentation/manager/chat_event.dart';
import 'package:fitness_app/features/chat/presentation/manager/chat_state.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

class PreviousConversationsDrawer extends StatelessWidget {
  const PreviousConversationsDrawer({super.key, required this.onNewChat});

  final VoidCallback onNewChat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = BorderRadius.horizontal(left: Radius.circular(24.r));
    final l10n = AppLocalizations.of(context)!;
    stdout.write('build PreviousConversationsDrawer');

    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.75,
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
                  Expanded(
                    child: Text(
                      l10n.previousConversations,
                      style: theme.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onNewChat();
                    },
                    icon: const Icon(
                      Icons.add_circle_sharp,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const Gap(12),
              Expanded(
                child: BlocBuilder<ChatCubit, ChatState>(
                  builder: (context, state) {
                    if (state.conversationsState.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }

                    final chats = state.conversationsState.data ?? const [];
                    if (chats.isEmpty) {
                      return Center(
                        child: Text(
                          l10n.noChatYet,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: chats.length,
                      separatorBuilder: (_, _) => Divider(
                        height: 1,
                        color: AppColors.textSecondary.withValues(alpha: 0.2),
                      ),
                      itemBuilder: (context, index) {
                        final chat = chats[index];
                        final isSelected = chat.id == state.activeChatId;

                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          dense: true,
                          selected: isSelected,
                          selectedTileColor: AppColors.primary.withValues(
                            alpha: 0.12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          leading: Icon(
                            Icons.chat_bubble_outline_rounded,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            size: 18.r,
                          ),
                          title: Text(
                            chat.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              size: 18.r,
                              color: AppColors.textMuted,
                            ),
                            onPressed: () {
                              context.read<ChatCubit>().onEvent(
                                DeleteConversationEvent(chat.id),
                              );
                            },
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            context.read<ChatCubit>().onEvent(
                              SelectConversationEvent(chat.id),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
