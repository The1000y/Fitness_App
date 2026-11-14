import 'package:fitness_app/features/chat/api/chat_api_client.dart';
import 'package:fitness_app/features/chat/data/datasource/remote/chat_remote_data_source.dart';
import 'package:fitness_app/features/chat/data/models/ollama/ollama_chat_request_dto.dart';
import 'package:fitness_app/features/chat/data/models/ollama/ollama_chat_response_dto.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ChatRemoteDataSource)
class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final ChatApiClient _apiClient;

  ChatRemoteDataSourceImpl(this._apiClient);

  @override
  Future<OllamaChatResponseDto> requestChatResponse({
    required OllamaChatRequestDto request,
  }) {
    return _apiClient.requestChatResponse(request);
  }
}
