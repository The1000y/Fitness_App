import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/config/di/di.dart';
import 'package:fitness_app/config/localization/app_failure_message_mapper.dart';
import 'package:fitness_app/core/constants/app_icons.dart';
import 'package:fitness_app/core/constants/app_images.dart';
import 'package:fitness_app/core/shared/base_ui_event_listener.dart';
import 'package:fitness_app/core/shared/custom_app_bar.dart';
import 'package:fitness_app/core/shared/custom_background_image.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/features/chat/presentation/manager/chat_cubit.dart';
import 'package:fitness_app/features/chat/presentation/manager/chat_event.dart';
import 'package:fitness_app/features/chat/presentation/manager/chat_state.dart';
import 'package:fitness_app/features/chat/presentation/view/widget/custom_chat_message.dart';
import 'package:fitness_app/features/chat/presentation/view/widget/previous_conversations_drawer.dart';
import 'package:fitness_app/features/profile/presentation/manager/profile_cubit.dart';
import 'package:fitness_app/features/profile/presentation/manager/profile_state.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/svg.dart';

class MessageView extends StatefulWidget {
  const MessageView({super.key});

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // الـ Cubit بييجي من الـ BlocProvider اللي في الـ Route، وهو اللي بيقفله
  ChatCubit get _chatCubit => context.read<ChatCubit>();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSend() {
    final text = _messageController.text.trim();
    if (text.isEmpty || _chatCubit.state.isSending) return;

    _messageController.clear();
    _chatCubit.onEvent(SendMessageEvent(text));
    _scrollToBottom();
  }

  ImageProvider _resolveUserAvatar(ProfileState profileState) {
    final photoUrl = profileState.profileState.data?.photo;
    if (photoUrl != null &&
        photoUrl.trim().isNotEmpty &&
        (photoUrl.startsWith('http://') || photoUrl.startsWith('https://'))) {
      return NetworkImage(photoUrl);
    }
    return const AssetImage(AppImages.logo);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BaseUiEventListener<ChatCubit, ChatState, BaseUiEvent>(
      cubit: _chatCubit,
      child: CustomBackgroundImage(
        backgroundImage: AppImages.chatBackground,
        child: Scaffold(
          endDrawer: PreviousConversationsDrawer(
            onNewChat: () {
              _chatCubit.onEvent(const StartNewChatEvent());
            },
          ),
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            actions: [
              Builder(
                builder: (drawerContext) {
                  return IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      _chatCubit.onEvent(const LoadPreviousChatsEvent());
                      Scaffold.of(drawerContext).openEndDrawer();
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
          body: BlocConsumer<ChatCubit, ChatState>(
            listener: (context, state) {
              // كل ما رسالة جديدة تضاف أو يبدأ التفكير، ننزل لآخر الشات بنعومة
              _scrollToBottom();
            },
            builder: (context, chatState) {
              if (chatState.messagesState.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (chatState.messagesState.errorMessage != null) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          size: 36.sp,
                          color: AppColors.primary,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          appFailureMessageMapper(
                            chatState.messagesState.errorMessage!,
                            l10n,
                          ),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        TextButton.icon(
                          onPressed: () {
                            _chatCubit.onEvent(const LoadPreviousChatsEvent());
                          },
                          icon: const Icon(Icons.refresh_rounded),
                          label: Text(l10n.tryAgain),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final uiMessages = chatState.messagesState.data ?? const [];

              if (uiMessages.isEmpty && !chatState.isSending) {
                return Center(
                  child: Image.asset(AppImages.robotSkippingWithARope),
                );
              }

              return BlocBuilder<ProfileCubit, ProfileState>(
                bloc: getIt<ProfileCubit>(),
                builder: (context, profileState) {
                  final userAvatar = _resolveUserAvatar(profileState);
                  // لو البوت بيفكر (isSending == true)، نزود عنصر واحد في الآخر لفقاعة الـ 3 نقط
                  final totalCount =
                      uiMessages.length + (chatState.isSending ? 1 : 0);

                  return ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 12.h,
                    ),
                    itemCount: totalCount,
                    itemBuilder: (context, index) {
                      // العنصر الأخير وقت التفكير هو فقاعة الـ Typing (3 نقط متحركة)
                      if (chatState.isSending && index == uiMessages.length) {
                        return CustomChatMessage(
                          text: '',
                          isSender: false,
                          isTyping: true,
                          senderAvatar: userAvatar,
                          receiverAvatar: const AssetImage(AppImages.robotChat),
                        );
                      }

                      final message = uiMessages[index];
                      return CustomChatMessage(
                        text: message.text,
                        isSender: message.isUser,
                        exercises: message.exercises,
                        meals: message.meals,
                        senderAvatar: userAvatar,
                        receiverAvatar: const AssetImage(AppImages.robotChat),
                      );
                    },
                  );
                },
              );
            },
          ),
          bottomNavigationBar: BlocBuilder<ChatCubit, ChatState>(
            builder: (context, chatState) {
              return Padding(
                padding: EdgeInsets.only(
                  left: 8.w,
                  right: 8.w,
                  top: 8.h,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 8.h,
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── شريط تحذير اقتراب انتهاء الـ Tokens (عند 85%) ──
                      if (chatState.showTokenLimitWarning)
                        Container(
                          margin: EdgeInsets.only(bottom: 8.h),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: AppColors.primary,
                                size: 18.r,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  l10n.chatLimitReached,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppColors.textPrimary,
                                    fontSize: 11.sp,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  _chatCubit.onEvent(const StartNewChatEvent());
                                },
                                child: Text(l10n.newConversation),
                              ),
                            ],
                          ),
                        ),

                      // ── حقل كتابة الرسالة وزرار الإرسال ──
                      TextField(
                        controller: _messageController,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _handleSend(),
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
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              chatState.isSending
                                  ? Icons.hourglass_top_rounded
                                  : Icons.send,
                            ),
                            color: chatState.isSending
                                ? AppColors.textMuted
                                : AppColors.primary,
                            onPressed: chatState.isSending ? null : _handleSend,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
