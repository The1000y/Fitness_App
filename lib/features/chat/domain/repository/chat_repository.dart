
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/chat/domain/entities/chat_entity.dart';
import 'package:fitness_app/features/chat/domain/entities/chat_response_entity.dart';
import 'package:fitness_app/features/chat/domain/entities/message_entity.dart';

abstract interface class ChatRepository {
  Future<BaseResponse<ChatResponseEntity>> sendMessage({
    required List<MessageEntity> conversationHistory,
  });

  Future<BaseResponse<ChatEntity>> createChat({
    required String title,
  });

  Future<BaseResponse<List<ChatEntity>>> getChats();

  Future<BaseResponse<void>> deleteChat({
    required String chatId,
  });
}
