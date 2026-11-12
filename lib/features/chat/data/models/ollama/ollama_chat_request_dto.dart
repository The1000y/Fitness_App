
import 'package:fitness_app/features/chat/data/models/ollama/ollama_message_dto.dart';
import 'package:fitness_app/features/chat/data/models/ollama/ollama_tool_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ollama_chat_request_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class OllamaChatRequestDto {
  final String model;
  final List<OllamaMessageDto> messages;
  final bool stream;
  final bool think;

  @JsonKey(includeIfNull: false)
  final List<OllamaToolDto>? tools;

  @JsonKey(includeIfNull: false)
  final Map<String, dynamic>? format;

  const OllamaChatRequestDto({
    required this.model,
    required this.messages,
    required this.stream,
    required this.think,
    this.tools,
    this.format,
  });

  factory OllamaChatRequestDto.forTools({
    required String model,
    required List<OllamaMessageDto> messages,
    required List<OllamaToolDto> tools,
  }) {
    return OllamaChatRequestDto(
      model: model,
      messages: messages,
      stream: false,
      think: false,
      tools: tools,
    );
  }

  factory OllamaChatRequestDto.forStructuredResponse({
    required String model,
    required List<OllamaMessageDto> messages,
    required Map<String, dynamic> format,
  }) {
    return OllamaChatRequestDto(
      model: model,
      messages: messages,
      stream: false,
      think: false,
      format: format,
    );
  }

  factory OllamaChatRequestDto.fromJson(Map<String, dynamic> json) =>
      _$OllamaChatRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OllamaChatRequestDtoToJson(this);
}
