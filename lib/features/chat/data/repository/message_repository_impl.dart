import 'package:injectable/injectable.dart';

import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/utils/execute_firestore_call.dart';

import 'package:fitness_app/features/chat/data/datasource/firestore/chat_firestore_data_source.dart';

import 'package:fitness_app/features/chat/domain/entities/message_entity.dart';
import 'package:fitness_app/features/chat/domain/repository/message_repository.dart';

@LazySingleton(as: MessageRepository)
class MessageRepositoryImpl implements MessageRepository {
  final ChatFirestoreDataSource _firestoreDataSource;

  MessageRepositoryImpl(this._firestoreDataSource);

  @override
  Future<BaseResponse<MessageEntity>> saveMessage({
    required MessageEntity message,
  }) async {
    return executeFirestoreCall(() async {
      final messageModel = await _firestoreDataSource.saveMessage(
        chatId: message.chatId,
        messageId: message.id,
        content: message.content,
        role: message.role,
      );

      return messageModel.toEntity(chatId: message.chatId);
    });
  }

  @override
  Future<BaseResponse<List<MessageEntity>>> getChatHistory({
    required String chatId,
  }) async {
    return executeFirestoreCall(() async {
      final messageModels = await _firestoreDataSource.getChatHistory(
        chatId: chatId,
      );

      return messageModels
          .map((model) => model.toEntity(chatId: chatId))
          .toList();
    });
  }
}
