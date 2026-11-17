sealed class ChatEvent {
  const ChatEvent();
}

class SendMessageEvent extends ChatEvent {
  final String message;
  const SendMessageEvent(this.message);
}

class LoadPreviousChatsEvent extends ChatEvent {
  const LoadPreviousChatsEvent();
}

class StartNewChatEvent extends ChatEvent {
  const StartNewChatEvent();
}

class SelectConversationEvent extends ChatEvent {
  final String chatId;
  const SelectConversationEvent(this.chatId);
}

class DeleteConversationEvent extends ChatEvent {
  final String chatId;
  const DeleteConversationEvent(this.chatId);
}
