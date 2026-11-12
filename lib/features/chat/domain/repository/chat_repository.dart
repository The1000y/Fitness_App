
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/chat/domain/entities/chat_entity.dart';
import 'package:fitness_app/features/chat/domain/entities/chat_response_entity.dart';
import 'package:fitness_app/features/chat/domain/entities/chat_tool_definition_entity.dart';
import 'package:fitness_app/features/chat/domain/entities/message_entity.dart';

abstract interface class ChatRepository {
  Future<BaseResponse<ChatResponseEntity>> requestCoachResponseWithTools({
    required List<MessageEntity> conversationHistory,
    required String systemPrompt,
    required List<ChatToolDefinitionEntity> availableTools,
  });

  Future<BaseResponse<ChatResponseEntity>> requestStructuredCoachResponse({
    required List<MessageEntity> conversationHistory,
    required String systemPrompt,
    required Map<String, dynamic> responseFormat,
  });

  Future<BaseResponse<ChatEntity>> createChat({
    required String title,
      required String userId,

  });

  Future<BaseResponse<List<ChatEntity>>> getChats({
    required String userId,
  });

  Future<BaseResponse<void>> deleteChat({
    required String chatId,
  });

  Future<BaseResponse<MessageEntity>> saveMessage({
    required MessageEntity message,
  });

  Future<BaseResponse<List<MessageEntity>>> getChatHistory({
    required String chatId,
    int limit = 50,
    DateTime? startAfter,
  });
}
