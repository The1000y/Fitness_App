import 'package:fitness_app/features/chat/data/models/firestore/message_model.dart';
import 'package:injectable/injectable.dart';

import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/config/utils/excecute_api_call.dart';
import 'package:fitness_app/config/utils/execute_firestore_call.dart';

import 'package:fitness_app/core/constants/api_strings.dart';

import 'package:fitness_app/features/chat/data/datasource/firestore/chat_firestore_data_source.dart';
import 'package:fitness_app/features/chat/data/datasource/remote/chat_remote_data_source.dart';

import 'package:fitness_app/features/chat/data/models/ollama/chat_request_dto.dart';
import 'package:fitness_app/features/chat/data/models/ollama/chat_response_dto.dart';
import 'package:fitness_app/features/chat/data/models/ollama/message_dto.dart';

import 'package:fitness_app/features/chat/domain/entities/chat_entity.dart';
import 'package:fitness_app/features/chat/domain/entities/chat_response_entity.dart';
import 'package:fitness_app/features/chat/domain/entities/message_entity.dart';

import 'package:fitness_app/features/chat/domain/repository/chat_repository.dart';

@LazySingleton(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final ChatFirestoreDataSource _firestoreDataSource;
  final ChatRemoteDataSource _remoteDataSource;

  ChatRepositoryImpl(this._firestoreDataSource, this._remoteDataSource);

  @override
  Future<BaseResponse<ChatEntity>> createChat({required String title}) async {
    return executeFirestoreCall(() async {
      final chatModel = await _firestoreDataSource.createChat(title: title);

      return chatModel.toEntity();
    });
  }

  @override
  Future<BaseResponse<List<ChatEntity>>> getChats() async {
    return executeFirestoreCall(() async {
      final chatModels = await _firestoreDataSource.getChats();

      return chatModels.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<BaseResponse<void>> deleteChat({required String chatId}) async {
    return executeFirestoreCall(() async {
      await _firestoreDataSource.deleteChat(chatId: chatId);
    });
  }

  @override
  Future<BaseResponse<ChatResponseEntity>> sendMessage({
    required List<MessageEntity> conversationHistory,
  }) async {
    // 1. Validate conversation history.
    if (conversationHistory.isEmpty ||
        conversationHistory.last.role != 'user') {
      return const Error<ChatResponseEntity>(
        ChatRequestFailure(ChatRequestFailureReason.latestMessageMustBeUser),
      );
    }

    final userMessage = conversationHistory.last;
    final chatId = userMessage.chatId;

    if (chatId.isEmpty) {
      return const Error<ChatResponseEntity>(
        ChatRequestFailure(ChatRequestFailureReason.chatIdCannotBeEmpty),
      );
    }

    final saveUserMessageResult = await executeFirestoreCall<MessageModel>(
      () async {
        return _firestoreDataSource.saveMessage(
          chatId: chatId,
          messageId: userMessage.id,
          content: userMessage.content,
          role: userMessage.role,
        );
      },
    );

    if (saveUserMessageResult is Error<MessageModel>) {
      return Error<ChatResponseEntity>(saveUserMessageResult.failure);
    }

    if (saveUserMessageResult is! Success<MessageModel>) {
      return const Error<ChatResponseEntity>(UnknownFailure());
    }

    final request = ChatRequestDto(
      model: ApiStrings.ollamaModel,
      messages: conversationHistory.map((message) {
        return MessageDto(role: message.role, content: message.content);
      }).toList(),
      stream: false,
    );

    final apiResult = await excecuteApiCall(
      () => _remoteDataSource.sendMessage(request: request),
    );

    if (apiResult is Error<ChatResponseDto>) {
      return Error<ChatResponseEntity>(apiResult.failure);
    }

    if (apiResult is! Success<ChatResponseDto>) {
      return const Error<ChatResponseEntity>(UnknownFailure());
    }

    final responseDto = apiResult.data;

    final assistantContent = responseDto.message?.content;

    if (assistantContent == null || assistantContent.trim().isEmpty) {
      return const Error<ChatResponseEntity>(
        ChatRequestFailure(ChatRequestFailureReason.emptyAssistantResponse),
      );
    }

    final saveAssistantResult = await executeFirestoreCall<void>(() async {
      await _firestoreDataSource.saveMessage(
        chatId: chatId,
        content: assistantContent,
        role: 'assistant',
      );
    });

    if (saveAssistantResult is Error<void>) {
      return Error<ChatResponseEntity>(saveAssistantResult.failure);
    }

    return Success<ChatResponseEntity>(responseDto.toEntity());
  }
}
