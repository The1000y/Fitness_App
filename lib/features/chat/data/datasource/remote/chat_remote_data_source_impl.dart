import 'package:fitness_app/features/chat/api/chat_api_client.dart';
import 'package:fitness_app/features/chat/data/datasource/remote/chat_remote_data_source.dart';
import 'package:fitness_app/features/chat/data/models/ollama/chat_request_dto.dart';
import 'package:fitness_app/features/chat/data/models/ollama/chat_response_dto.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ChatRemoteDataSource)
class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final ChatApiClient _apiClient;

  ChatRemoteDataSourceImpl(this._apiClient);

  @override
  Future<ChatResponseDto> sendMessage({
    required ChatRequestDto request,
  }) {
    return _apiClient.sendMessage(request);
  }
}