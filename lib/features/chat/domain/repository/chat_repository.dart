
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/chat/domain/entities/chat_entity.dart';
import 'package:fitness_app/features/chat/domain/entities/chat_page_entity.dart';
import 'package:fitness_app/features/chat/domain/entities/chat_response_entity.dart';
import 'package:fitness_app/features/chat/domain/entities/message_entity.dart';

abstract interface class ChatRepository {
  Future<BaseResponse<ChatResponseEntity>> requestCoachResponseWithTools({
    required List<MessageEntity> conversationHistory,
    required List<String> muscleGroups,
    required List<String> difficulties,
    required List<String> equipment,
    required List<String> mealCategories,
    required List<String> mealAreas,
  });

  Future<BaseResponse<ChatResponseEntity>> requestStructuredCoachResponse({
    required List<MessageEntity> conversationHistory,
  });
  Future<BaseResponse<ChatEntity>> createChat({
    required String title,
    required String userId,
  });

  Future<BaseResponse<ChatPageEntity>> getChats({
    required String userId,
    int limit = 20,
    ChatEntity? lastChat,
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
