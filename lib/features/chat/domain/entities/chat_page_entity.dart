
import 'package:fitness_app/features/chat/domain/entities/chat_entity.dart';

class ChatPageEntity {
  final List<ChatEntity> chats;
  final bool hasMore;

  const ChatPageEntity({
    required this.chats,
    required this.hasMore,
  });
}
