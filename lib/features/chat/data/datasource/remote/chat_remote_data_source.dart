import 'package:fitness_app/features/chat/data/models/ollama/ollama_chat_request_dto.dart';
import 'package:fitness_app/features/chat/data/models/ollama/ollama_chat_response_dto.dart';

abstract interface class ChatRemoteDataSource {
  Future<OllamaChatResponseDto> requestChatResponse({
    required OllamaChatRequestDto request,
  });
}
