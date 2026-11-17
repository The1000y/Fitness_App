import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/chat/domain/entities/chat_entity.dart';
import 'package:fitness_app/features/chat/domain/entities/message_entity.dart';
import 'package:fitness_app/features/chat/domain/repository/catalog_repository.dart';
import 'package:fitness_app/features/chat/domain/repository/chat_repository.dart';
import 'package:fitness_app/features/chat/domain/use_cases/create_chat_use_case.dart';
import 'package:fitness_app/features/chat/domain/use_cases/send_message_use_case.dart';
import 'package:fitness_app/features/chat/presentation/manager/chat_cubit.dart';
import 'package:fitness_app/features/chat/presentation/manager/chat_event.dart';
import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSendMessageUseCase extends Mock implements SendMessageUseCase {}

class MockCreateChatUseCase extends Mock implements CreateChatUseCase {}

class MockChatRepository extends Mock implements ChatRepository {}

class MockCatalogRepository extends Mock implements CatalogRepository {}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockSendMessageUseCase sendMessageUseCase;
  late MockCreateChatUseCase createChatUseCase;
  late MockChatRepository chatRepository;
  late MockCatalogRepository catalogRepository;
  late MockFlutterSecureStorage storage;
  late ChatCubit cubit;

  setUpAll(() {
    registerFallbackValue(<MessageEntity>[]);
  });

  setUp(() {
    sendMessageUseCase = MockSendMessageUseCase();
    createChatUseCase = MockCreateChatUseCase();
    chatRepository = MockChatRepository();
    catalogRepository = MockCatalogRepository();
    storage = MockFlutterSecureStorage();
    cubit = ChatCubit(
      sendMessageUseCase,
      createChatUseCase,
      chatRepository,
      catalogRepository,
      storage,
    );

    when(
      () => storage.read(key: any(named: 'key')),
    ).thenAnswer((_) async => 'user-id');
  });

  tearDown(() async {
    await cubit.close();
  });

  test('handles failure gracefully and emits ShowFailureMessage', () async {
    when(
      () => createChatUseCase(
        userId: any(named: 'userId'),
        userText: any(named: 'userText'),
      ),
    ).thenAnswer((_) async => Success(_chat('chat-123')));
    when(
      () => sendMessageUseCase(
        chatId: 'chat-123',
        userText: any(named: 'userText'),
        conversationHistory: any(named: 'conversationHistory'),
      ),
    ).thenAnswer((_) async => const Error<ChatOutput>(UnknownFailure()));

    final eventFuture = cubit.uiEventStream.first;
    await cubit.onEvent(const SendMessageEvent('  Try again  '));

    expect(cubit.state.isSending, isFalse);
    expect(cubit.state.activeChatId, 'chat-123');
    expect(cubit.state.messagesState.data?.length, 1);
    expect(cubit.state.messagesState.data?.first.text, 'Try again');
    expect(await eventFuture, isA<ShowFailureMessage>());
  });

  test('does not send a message if chat creation fails', () async {
    when(
      () => createChatUseCase(
        userId: any(named: 'userId'),
        userText: any(named: 'userText'),
      ),
    ).thenAnswer((_) async => const Error<ChatEntity>(UnknownFailure()));

    final eventFuture = cubit.uiEventStream.first;
    await cubit.onEvent(const SendMessageEvent('Hello'));

    expect(cubit.state.isSending, isFalse);
    expect(await eventFuture, isA<ShowFailureMessage>());
    verifyNever(
      () => sendMessageUseCase(
        chatId: any(named: 'chatId'),
        userText: any(named: 'userText'),
        conversationHistory: any(named: 'conversationHistory'),
      ),
    );
  });

  test('adds response and updates activeChatId on success', () async {
    when(
      () => createChatUseCase(
        userId: any(named: 'userId'),
        userText: any(named: 'userText'),
      ),
    ).thenAnswer((_) async => Success(_chat('chat-123')));
    when(
      () => sendMessageUseCase(
        chatId: 'chat-123',
        userText: any(named: 'userText'),
        conversationHistory: any(named: 'conversationHistory'),
      ),
    ).thenAnswer(
      (_) async => const Success<ChatOutput>(
        ChatOutput(
          chatId: 'chat-123',
          answerText: 'Hello there!',
          exercises: [],
          meals: [],
          totalTokensUsed: 100,
          isNearTokenLimit: false,
        ),
      ),
    );

    await cubit.onEvent(const SendMessageEvent('Hello'));

    expect(cubit.state.isSending, isFalse);
    expect(cubit.state.activeChatId, 'chat-123');
    expect(cubit.state.messagesState.data?.length, 2);
    expect(cubit.state.messagesState.data?.first.text, 'Hello');
    expect(cubit.state.messagesState.data?.last.text, 'Hello there!');
    expect(cubit.state.messagesState.data?.last.isUser, isFalse);
    expect(cubit.state.conversationHistory.map((message) => message.role), [
      'user',
      'assistant',
    ]);
    verify(
      () => createChatUseCase(userId: 'user-id', userText: 'Hello'),
    ).called(1);
    verifyNoMoreInteractions(createChatUseCase);
    verify(
      () => sendMessageUseCase(
        chatId: 'chat-123',
        userText: 'Hello',
        conversationHistory: const [],
      ),
    ).called(1);
  });

  test('reuses the active chat on subsequent messages', () async {
    when(
      () => createChatUseCase(
        userId: any(named: 'userId'),
        userText: any(named: 'userText'),
      ),
    ).thenAnswer((_) async => Success(_chat('chat-123')));
    when(
      () => sendMessageUseCase(
        chatId: 'chat-123',
        userText: any(named: 'userText'),
        conversationHistory: any(named: 'conversationHistory'),
      ),
    ).thenAnswer(
      (_) async => const Success<ChatOutput>(
        ChatOutput(
          chatId: 'chat-123',
          answerText: 'Response',
          exercises: [],
          meals: [],
          totalTokensUsed: 0,
          isNearTokenLimit: false,
        ),
      ),
    );

    await cubit.onEvent(const SendMessageEvent('Hello'));
    await cubit.onEvent(const SendMessageEvent('Second message'));

    verify(
      () => createChatUseCase(userId: 'user-id', userText: 'Hello'),
    ).called(1);
    verify(
      () => sendMessageUseCase(
        chatId: 'chat-123',
        userText: 'Second message',
        conversationHistory: any(named: 'conversationHistory'),
      ),
    ).called(1);
    expect(cubit.state.conversationHistory.length, 4);
    expect(cubit.state.conversationHistory[2].content, 'Second message');
  });

  test('loads and reuses selected chat history for sends', () async {
    final userMessage = MessageEntity(
      id: 'user-message',
      chatId: 'chat-123',
      content: 'Earlier question',
      role: 'user',
      createdAt: DateTime(2026),
    );
    final assistantMessage = MessageEntity(
      id: 'assistant-message',
      chatId: 'chat-123',
      content: 'Earlier answer',
      role: 'assistant',
      createdAt: DateTime(2026, 1, 2),
    );
    when(
      () => chatRepository.getChatHistory(chatId: 'chat-123'),
    ).thenAnswer((_) async => Success([assistantMessage, userMessage]));
    when(
      () => sendMessageUseCase(
        chatId: 'chat-123',
        userText: 'Follow-up',
        conversationHistory: [userMessage, assistantMessage],
      ),
    ).thenAnswer(
      (_) async => const Success<ChatOutput>(
        ChatOutput(
          chatId: 'chat-123',
          answerText: 'Follow-up answer',
          exercises: [],
          meals: [],
          totalTokensUsed: 0,
          isNearTokenLimit: false,
        ),
      ),
    );

    await cubit.onEvent(const SelectConversationEvent('chat-123'));
    await cubit.onEvent(const SendMessageEvent('Follow-up'));

    expect(cubit.state.conversationHistory.map((message) => message.content), [
      'Earlier question',
      'Earlier answer',
      'Follow-up',
      'Follow-up answer',
    ]);
    verify(() => chatRepository.getChatHistory(chatId: 'chat-123')).called(1);
  });
}

ChatEntity _chat(String id) => ChatEntity(
  id: id,
  title: 'Hello',
  userId: 'user-id',
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
);
