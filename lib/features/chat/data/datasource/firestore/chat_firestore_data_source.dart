
import 'package:fitness_app/features/chat/data/models/firestore/chat_model.dart';
import 'package:fitness_app/features/chat/data/models/firestore/chat_page_model.dart';
import 'package:fitness_app/features/chat/data/models/firestore/chat_message_model.dart';
import 'package:fitness_app/features/chat/domain/entities/chat_tool_definition_entity.dart';

abstract interface class ChatFirestoreDataSource {
  Future<ChatModel> createChat({
    required String title,
    required String userId,
  });

  Future<ChatPageModel> getChats({
    required String userId,
    int limit = 20,
    DateTime? startAfterUpdatedAt,
    String? startAfterId,
  });

  Future<void> deleteChat({
    required String chatId,
  });

  Future<ChatMessageModel> saveMessage({
    required String chatId,
    String? messageId,
    required String content,
    required String role,
    String? toolName,
    String? toolCallId,
    List<ToolCallEntity> toolCalls = const [],
    List<String> exerciseIds = const [],
    List<String> mealIds = const [],
    int tokensUsed = 0,
  });

  Future<List<ChatMessageModel>> getChatHistory({
    required String chatId,
    int limit = 50,
    DateTime? startAfter,
  });
}
