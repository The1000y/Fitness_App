
import 'package:fitness_app/features/chat/data/models/firestore/chat_model.dart';
import 'package:fitness_app/features/chat/domain/entities/chat_page_entity.dart';

class ChatPageModel {
  final List<ChatModel> chats;
  final bool hasMore;

  const ChatPageModel({
    required this.chats,
    required this.hasMore,
  });

  ChatPageEntity toEntity() {
    return ChatPageEntity(
      chats: chats.map((chat) => chat.toEntity()).toList(),
      hasMore: hasMore,
    );
  }
}
