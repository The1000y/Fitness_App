
import 'package:fitness_app/features/chat/data/models/firestore/chat_model.dart';
import 'package:fitness_app/features/chat/data/models/firestore/message_model.dart';

abstract interface class ChatFirestoreDataSource {
  Future<ChatModel> createChat({
    required String title,
    required String userId,

  });

  Future<List<ChatModel>> getChats();

  Future<void> deleteChat({
    required String chatId,
  });

  Future<MessageModel> saveMessage({
  required String chatId,
  String? messageId,
  required String content,
  required String role,
});
  Future<List<MessageModel>> getChatHistory({
    required String chatId,
  });
}
