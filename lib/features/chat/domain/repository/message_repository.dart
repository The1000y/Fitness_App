
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/chat/domain/entities/message_entity.dart';

abstract interface class MessageRepository {
  Future<BaseResponse<MessageEntity>> saveMessage({
    required MessageEntity message,
  });

  Future<BaseResponse<List<MessageEntity>>> getChatHistory({
    required String chatId,
  });
}
