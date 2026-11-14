import 'package:fitness_app/features/chat/domain/entities/chat_page_entity.dart';
import 'package:injectable/injectable.dart';

import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/utils/excecute_api_call.dart';
import 'package:fitness_app/config/utils/execute_firestore_call.dart';

import 'package:fitness_app/core/constants/api_strings.dart';

import 'package:fitness_app/features/chat/data/datasource/firestore/chat_firestore_data_source.dart';
import 'package:fitness_app/features/chat/data/datasource/remote/chat_remote_data_source.dart';

import 'package:fitness_app/features/chat/data/models/ollama/ollama_chat_request_dto.dart';
import 'package:fitness_app/features/chat/data/models/ollama/ollama_message_dto.dart';
import 'package:fitness_app/features/chat/data/models/ollama/ollama_tool_dto.dart';

import 'package:fitness_app/features/chat/domain/entities/chat_entity.dart';
import 'package:fitness_app/features/chat/domain/entities/chat_response_entity.dart';
import 'package:fitness_app/features/chat/domain/entities/message_entity.dart';

import 'package:fitness_app/features/chat/domain/repository/chat_repository.dart';

import '../../domain/coach/coach_prompt_and_schemas.dart';

@Injectable(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final ChatFirestoreDataSource _firestoreDataSource;
  final ChatRemoteDataSource _remoteDataSource;

  ChatRepositoryImpl(this._firestoreDataSource, this._remoteDataSource);

  @override
  Future<BaseResponse<ChatEntity>> createChat({
    required String title,
    required String userId,
  }) async {
    return executeFirestoreCall(() async {
      final chatModel = await _firestoreDataSource.createChat(
        title: title,
        userId: userId,
      );

      return chatModel.toEntity();
    });
  }


@override
Future<BaseResponse<ChatPageEntity>> getChats({
  required String userId,
  int limit = 20,
  ChatEntity? lastChat,
}) async {
  return executeFirestoreCall(() async {
    final chatPage = await _firestoreDataSource.getChats(
      userId: userId,
      limit: limit,
      startAfterUpdatedAt: lastChat?.updatedAt,
      startAfterId: lastChat?.id,
    );

    return chatPage.toEntity();
  });
}


  @override
  Future<BaseResponse<void>> deleteChat({required String chatId}) async {
    return executeFirestoreCall(() async {
      await _firestoreDataSource.deleteChat(chatId: chatId);
    });
  }

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
        toolName: message.toolName,
        toolCallId: message.toolCallId,
        toolCalls: message.toolCalls,
        exerciseIds: message.exerciseIds,
        mealIds: message.mealIds,
        tokensUsed: message.tokensUsed,
      );

      return messageModel.toEntity(chatId: message.chatId);
    });
  }

  @override
  Future<BaseResponse<List<MessageEntity>>> getChatHistory({
    required String chatId,
    int limit = 50,
    DateTime? startAfter,
  }) async {
    return executeFirestoreCall(() async {
      final messageModels = await _firestoreDataSource.getChatHistory(
        chatId: chatId,
        limit: limit,
        startAfter: startAfter,
      );

      return messageModels
          .map((model) => model.toEntity(chatId: chatId))
          .toList();
    });
  }

  
@override
Future<BaseResponse<ChatResponseEntity>> requestCoachResponseWithTools({
  required List<MessageEntity> conversationHistory,
  required List<String> muscleGroups,
  required List<String> difficulties,
  required List<String> equipment,
  required List<String> mealCategories,
  required List<String> mealAreas,
}) async {
  final systemPrompt = CoachPromptAndSchemas.buildSystemPrompt(
    muscleGroups: muscleGroups,
    difficulties: difficulties,
    equipment: equipment,
    mealCategories: mealCategories,
    mealAreas: mealAreas,
  );

  final availableTools = CoachPromptAndSchemas.buildAvailableTools(
    muscleGroups: muscleGroups,
    difficulties: difficulties,
    equipment: equipment,
    mealCategories: mealCategories,
    mealAreas: mealAreas,
  );

  final request = OllamaChatRequestDto.forTools(
    model: ApiStrings.ollamaModel,
    messages: _buildMessages(
      systemPrompt: systemPrompt,
      conversationHistory: conversationHistory,
    ),
    tools: availableTools.map(OllamaToolDto.fromEntity).toList(),
  );

  return _requestChatResponse(request);
}


 
@override
Future<BaseResponse<ChatResponseEntity>> requestStructuredCoachResponse({
  required List<MessageEntity> conversationHistory,
}) async {
  final systemPrompt = CoachPromptAndSchemas.buildSystemPrompt(
    muscleGroups: [],
    difficulties: [],
    equipment: [],
    mealCategories: [],
    mealAreas: [],
  );

  final request = OllamaChatRequestDto.forStructuredResponse(
    model: ApiStrings.ollamaModel,
    messages: _buildMessages(
      systemPrompt: systemPrompt,
      conversationHistory: conversationHistory,
    ),
    format: CoachPromptAndSchemas.answerSchema,
  );

  return _requestChatResponse(request);
}


  Future<BaseResponse<ChatResponseEntity>> _requestChatResponse(
    OllamaChatRequestDto request,
  ) async {
    final apiResult = await excecuteApiCall(
      () => _remoteDataSource.requestChatResponse(request: request),
    );

    return switch (apiResult) {
      Success(data: final response) => Success(response.toEntity()),
      Error(failure: final failure) => Error(failure),
      _ => throw StateError('Unexpected chat response state.'),
    };
  }

  List<OllamaMessageDto> _buildMessages({
    required String systemPrompt,
    required List<MessageEntity> conversationHistory,
  }) {
    return [
      OllamaMessageDto.system(systemPrompt),
      ...conversationHistory
          .where((message) => message.role != 'system')
          .map(OllamaMessageDto.fromEntity),
    ];
  }
}
