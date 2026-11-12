import 'package:dio/dio.dart';
import 'package:fitness_app/core/constants/api_strings.dart';
import 'package:fitness_app/features/chat/data/models/ollama/ollama_chat_request_dto.dart';
import 'package:fitness_app/features/chat/data/models/ollama/ollama_chat_response_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'chat_api_client.g.dart';

@singleton
@RestApi()
abstract class ChatApiClient {
  @factoryMethod
  factory ChatApiClient(
    @Named(ApiStrings.namedOllamaDio) Dio dio,
  ) = _ChatApiClient;

  @POST(ApiStrings.ollamaChat)
  Future<OllamaChatResponseDto> requestChatResponse(
    @Body() OllamaChatRequestDto request,
  );
}
