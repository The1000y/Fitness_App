import 'package:equatable/equatable.dart';
import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/features/chat/domain/entities/chat_entity.dart';
import 'package:fitness_app/features/chat/domain/entities/message_entity.dart';
import 'package:fitness_app/features/chat/presentation/manager/helper_classes/class_ui_message.dart';

class ChatState extends Equatable {
  final BaseState<List<ChatUiMessage>> messagesState;
  final BaseState<List<ChatEntity>> conversationsState;
  final List<MessageEntity> conversationHistory;
  final String? activeChatId;
  final bool isSending;
  final bool showTokenLimitWarning;

  const ChatState({
    this.messagesState = const BaseState(data: []),
    this.conversationsState = const BaseState(data: []),
    this.conversationHistory = const [],
    this.activeChatId,
    this.isSending = false,
    this.showTokenLimitWarning = false,
  });

  ChatState copyWith({
    String? activeChatId,
    bool clearActiveChatId = false,
    BaseState<List<ChatUiMessage>>? messagesState,
    BaseState<List<ChatEntity>>? conversationsState,
    List<MessageEntity>? conversationHistory,
    bool? isSending,
    bool? showTokenLimitWarning,
  }) {
    return ChatState(
      activeChatId: clearActiveChatId
          ? null
          : (activeChatId ?? this.activeChatId),
      messagesState: messagesState ?? this.messagesState,
      conversationsState: conversationsState ?? this.conversationsState,
      conversationHistory: conversationHistory ?? this.conversationHistory,
      isSending: isSending ?? this.isSending,
      showTokenLimitWarning:
          showTokenLimitWarning ?? this.showTokenLimitWarning,
    );
  }

  @override
  List<Object?> get props => [
    messagesState,
    conversationsState,
    conversationHistory,
    activeChatId,
    isSending,
    showTokenLimitWarning,
  ];
}
