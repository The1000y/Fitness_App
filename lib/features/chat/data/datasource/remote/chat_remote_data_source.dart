import 'package:fitness_app/features/chat/data/models/ollama/chat_request_dto.dart';
import 'package:fitness_app/features/chat/data/models/ollama/chat_response_dto.dart';

abstract interface class ChatRemoteDataSource {
  Future<ChatResponseDto> sendMessage({
    required ChatRequestDto request,
  });
}