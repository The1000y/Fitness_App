import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/chat/domain/entities/catalog_filter_metadata.dart';
import 'package:fitness_app/features/chat/domain/entities/chat_response_entity.dart';
import 'package:fitness_app/features/chat/domain/entities/message_entity.dart';
import 'package:fitness_app/features/chat/domain/repository/catalog_repository.dart';
import 'package:fitness_app/features/chat/domain/repository/chat_repository.dart';
import 'package:fitness_app/features/chat/domain/use_cases/send_message_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCatalogRepository extends Mock implements CatalogRepository {}

class MockChatRepository extends Mock implements ChatRepository {}

class FakeMessageEntity extends Fake implements MessageEntity {}

void main() {
  late MockCatalogRepository catalogRepository;
  late MockChatRepository chatRepository;
  late SendMessageUseCase useCase;

  setUpAll(() {
    registerFallbackValue(FakeMessageEntity());
  });

  setUp(() {
    catalogRepository = MockCatalogRepository();
    chatRepository = MockChatRepository();
    useCase = SendMessageUseCase(catalogRepository, chatRepository);

    when(() => catalogRepository.getFilterMetadata()).thenAnswer(
      (_) async => const CatalogFilterMetadata(
        muscleGroups: [],
        difficulties: [],
        equipments: [],
        mealCategories: [],
        mealAreas: [],
      ),
    );
  });

  test('uses supplied history without loading chat history', () async {
    final previousMessage = MessageEntity(
      id: 'message-id',
      chatId: 'chat-id',
      content: 'My message',
      role: 'user',
      createdAt: DateTime(2026),
    );
    when(
      () => chatRepository.requestCoachResponseWithTools(
        conversationHistory: [previousMessage],
        muscleGroups: any(named: 'muscleGroups'),
        difficulties: any(named: 'difficulties'),
        equipment: any(named: 'equipment'),
        mealCategories: any(named: 'mealCategories'),
        mealAreas: any(named: 'mealAreas'),
      ),
    ).thenAnswer(
      (_) async => const Error<ChatResponseEntity>(UnknownFailure()),
    );

    final result = await useCase(
      chatId: 'chat-id',
      userText: 'My message',
      conversationHistory: [previousMessage],
    );

    expect(result, isA<Error<ChatOutput>>());
    expect((result as Error<ChatOutput>).failure, isA<UnknownFailure>());
    verifyNever(
      () => chatRepository.getChatHistory(chatId: 'chat-id', limit: 20),
    );
    verify(
      () => chatRepository.requestCoachResponseWithTools(
        conversationHistory: [previousMessage],
        muscleGroups: [],
        difficulties: [],
        equipment: [],
        mealCategories: [],
        mealAreas: [],
      ),
    ).called(1);
  });

  test(
    'returns catalog metadata failure without loading chat history',
    () async {
      const failure = ServerFailure();
      when(
        () => catalogRepository.getFilterMetadata(),
      ).thenAnswer((_) async => throw failure);

      final result = await useCase(
        chatId: 'chat-id',
        userText: 'My message',
        conversationHistory: const [],
      );

      expect(result, isA<Error<ChatOutput>>());
      expect((result as Error<ChatOutput>).failure, same(failure));
      verifyNever(
        () => chatRepository.getChatHistory(chatId: 'chat-id', limit: 20),
      );
    },
  );
}
