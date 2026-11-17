// features/chat/presentation/manager/chat_cubit.dart
import 'package:fitness_app/config/base/base_cubit.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/core/constants/storage_keys.dart';
import 'package:fitness_app/features/chat/domain/entities/message_entity.dart';
import 'package:fitness_app/features/chat/domain/repository/catalog_repository.dart';
import 'package:fitness_app/features/chat/domain/repository/chat_repository.dart';
import 'package:fitness_app/features/chat/domain/use_cases/create_chat_use_case.dart';
import 'package:fitness_app/features/chat/domain/use_cases/send_message_use_case.dart';
import 'package:fitness_app/features/chat/presentation/manager/helper_classes/class_ui_message.dart';
import 'package:fitness_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_entity.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import 'chat_event.dart';
import 'chat_state.dart';

@injectable
class ChatCubit extends BaseCubit<ChatState, BaseUiEvent> {
  final SendMessageUseCase _sendMessageUseCase;
  final CreateChatUseCase _createChatUseCase;
  final ChatRepository _chatRepository;
  final CatalogRepository _catalogRepository;
  final FlutterSecureStorage _storage;

  ChatCubit(
    this._sendMessageUseCase,
    this._createChatUseCase,
    this._chatRepository,
    this._catalogRepository,
    this._storage,
  ) : super(const ChatState());

  Future<String> _getUserId() async {
    final storedId = await _storage.read(key: StorageKeys.kUserId);
    if (storedId != null && storedId.trim().isNotEmpty) {
      return storedId.trim();
    }
    return 'default_user';
  }

  Future<void> onEvent(ChatEvent event) async {
    switch (event) {
      case SendMessageEvent(message: final text):
        await _sendMessage(text);
      case StartNewChatEvent():
        emit(
          state.copyWith(
            clearActiveChatId: true,
            messagesState: const BaseState(data: []),
            conversationHistory: const [],
            showTokenLimitWarning: false,
          ),
        );
      case LoadPreviousChatsEvent():
        await _loadPreviousChats();
      case SelectConversationEvent(:final chatId):
        await _selectConversation(chatId);
      case DeleteConversationEvent():
        await _deleteConversation(event.chatId);
    }
  }

  Future<void> _sendMessage(String text) async {
    final newText = text.trim();
    if (newText.isEmpty || state.isSending) return;

    final conversationHistory = state.conversationHistory;
    final currentMessages = List<ChatUiMessage>.from(
      state.messagesState.data ?? const [],
    )..add(ChatUiMessage(isUser: true, text: newText));

    emit(
      state.copyWith(
        messagesState: state.messagesState.copyWith(data: currentMessages),
        isSending: true,
      ),
    );

    final userId = await _getUserId();
    final String chatId;
    final existingChatId = state.activeChatId;
    if (existingChatId == null || existingChatId.trim().isEmpty) {
      final createChatResult = await _createChatUseCase(
        userId: userId,
        userText: newText,
      );
      switch (createChatResult) {
        case Success(data: final chat):
          chatId = chat.id;
          emit(state.copyWith(activeChatId: chatId));
        case Error(failure: final failure):
          emit(state.copyWith(isSending: false));
          emitEvent(ShowFailureMessage(failure));
          return;
      }
    } else {
      chatId = existingChatId;
    }

    final result = await _sendMessageUseCase(
      chatId: chatId,
      userText: newText,
      conversationHistory: conversationHistory,
    );

    switch (result) {
      case Success(data: final output):
        final recentHistory = conversationHistory.length > 20
            ? conversationHistory.sublist(conversationHistory.length - 20)
            : conversationHistory;
        final previousTokens = recentHistory.fold<int>(
          0,
          (sum, message) => sum + message.tokensUsed,
        );
        final updatedHistory = List<MessageEntity>.from(conversationHistory)
          ..add(
            MessageEntity(
              id: '',
              chatId: output.chatId,
              content: newText,
              role: 'user',
              createdAt: DateTime.now(),
            ),
          )
          ..add(
            MessageEntity(
              id: '',
              chatId: output.chatId,
              content: output.answerText,
              role: 'assistant',
              exerciseIds: output.exercises
                  .map((exercise) => exercise.id)
                  .toList(),
              mealIds: output.meals.map((meal) => meal.id).toList(),
              tokensUsed: output.totalTokensUsed - previousTokens,
              createdAt: DateTime.now(),
            ),
          );
        final updatedMessages = List<ChatUiMessage>.from(currentMessages)
          ..add(
            ChatUiMessage(
              isUser: false,
              text: output.answerText,
              exercises: output.exercises,
              meals: output.meals,
            ),
          );
        emit(
          state.copyWith(
            activeChatId: output.chatId,
            messagesState: state.messagesState.copyWith(data: updatedMessages),
            conversationHistory: updatedHistory,
            isSending: false,
            showTokenLimitWarning: output.isNearTokenLimit,
          ),
        );
      case Error(failure: final failure):
        emit(state.copyWith(isSending: false));
        emitEvent(ShowFailureMessage(failure));
    }
  }

  Future<void> _loadPreviousChats() async {
    emit(
      state.copyWith(
        conversationsState: state.conversationsState.copyWith(
          isLoading: true,
          errorMessage: null,
        ),
      ),
    );

    final result = await _chatRepository.getChats(userId: await _getUserId());

    switch (result) {
      case Success(data: final page):
        emit(
          state.copyWith(
            conversationsState: BaseState(isLoading: false, data: page.chats),
          ),
        );

      case Error(failure: final failure):
        emit(
          state.copyWith(
            conversationsState: state.conversationsState.copyWith(
              isLoading: false,
              errorMessage: failure,
            ),
          ),
        );
        emitEvent(ShowFailureMessage(failure));
    }
  }

  Future<void> _selectConversation(String chatId) async {
    emit(
      state.copyWith(
        activeChatId: chatId,
        conversationHistory: const [],
        messagesState: state.messagesState.copyWith(
          isLoading: true,
          errorMessage: null,
        ),
        showTokenLimitWarning: false,
      ),
    );

    final result = await _chatRepository.getChatHistory(chatId: chatId);

    switch (result) {
      case Success(data: final messages):
        final chronologicalMessages = messages.reversed.toList();
        final uiMessages = <ChatUiMessage>[];
        int totalTokens = 0;

        for (final m in chronologicalMessages) {
          totalTokens += m.tokensUsed;

          if (m.role != 'user' && m.role != 'assistant') continue;
          if (m.role == 'assistant' && m.content.trim().isEmpty) continue;

          final exercises = m.exerciseIds.isEmpty
              ? const <ExerciseEntity>[]
              : await _catalogRepository.getExercisesByIds(m.exerciseIds);
          final meals = m.mealIds.isEmpty
              ? const <MealEntity>[]
              : await _catalogRepository.getMealsByIds(m.mealIds);

          uiMessages.add(
            ChatUiMessage(
              isUser: m.role == 'user',
              text: m.content,
              exercises: exercises,
              meals: meals,
            ),
          );
        }

        emit(
          state.copyWith(
            messagesState: BaseState(isLoading: false, data: uiMessages),
            conversationHistory: chronologicalMessages,
            showTokenLimitWarning:
                totalTokens >= (SendMessageUseCase.maxSessionTokens * 0.85),
          ),
        );

      case Error(failure: final failure):
        emit(
          state.copyWith(
            messagesState: state.messagesState.copyWith(
              isLoading: false,
              errorMessage: failure,
            ),
          ),
        );
        emitEvent(ShowFailureMessage(failure));
    }
  }

  Future<void> _deleteConversation(String chatId) async {
    final result = await _chatRepository.deleteChat(chatId: chatId);

    switch (result) {
      case Success():
        final updatedChats = (state.conversationsState.data ?? const [])
            .where((chat) => chat.id != chatId)
            .toList();

        final bool isDeletingActive = state.activeChatId == chatId;

        emit(
          state.copyWith(
            clearActiveChatId: isDeletingActive,
            messagesState: isDeletingActive
                ? const BaseState(data: [])
                : state.messagesState,
            conversationHistory: isDeletingActive
                ? const []
                : state.conversationHistory,
            showTokenLimitWarning: isDeletingActive
                ? false
                : state.showTokenLimitWarning,
            conversationsState: state.conversationsState.copyWith(
              data: updatedChats,
            ),
          ),
        );

      case Error(failure: final failure):
        emitEvent(ShowFailureMessage(failure));
    }
  }
}
