import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/features/chat/domain/entities/chat_entity.dart';
import 'package:fitness_app/features/chat/domain/repository/chat_repository.dart';
import 'package:fitness_app/features/chat/domain/use_cases/create_chat_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late MockChatRepository chatRepository;
  late CreateChatUseCase useCase;

  setUp(() {
    chatRepository = MockChatRepository();
    useCase = CreateChatUseCase(chatRepository);
  });

  test('creates a chat with the existing truncated title behavior', () async {
    final userText = List.filled(31, 'a').join();
    final title = '${userText.substring(0, 30)}...';
    final chat = ChatEntity(
      id: 'chat-id',
      title: title,
      userId: 'user-id',
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );
    when(
      () => chatRepository.createChat(title: title, userId: 'user-id'),
    ).thenAnswer((_) async => Success(chat));

    final result = await useCase(userId: 'user-id', userText: userText);

    expect(result, isA<Success<ChatEntity>>());
    expect((result as Success<ChatEntity>).data, chat);
    verify(
      () => chatRepository.createChat(title: title, userId: 'user-id'),
    ).called(1);
  });
}
