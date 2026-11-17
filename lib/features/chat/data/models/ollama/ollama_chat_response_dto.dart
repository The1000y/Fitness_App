import 'package:fitness_app/features/chat/data/models/ollama/ollama_message_dto.dart';
import 'package:fitness_app/features/chat/domain/entities/chat_response_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ollama_chat_response_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class OllamaChatResponseDto {
  final String? model;
  final OllamaMessageDto? message;
  final bool? done;

  @JsonKey(name: 'prompt_eval_count')
  final int? promptEvalCount;

  @JsonKey(name: 'prompt_eval_cached_count')
  final int? promptEvalCachedCount;

  @JsonKey(name: 'eval_count')
  final int? evalCount;

  const OllamaChatResponseDto({
    this.model,
    this.message,
    this.done,
    this.promptEvalCount,
    this.promptEvalCachedCount,
    this.evalCount,
  });

  factory OllamaChatResponseDto.fromJson(Map<String, dynamic> json) =>
      _$OllamaChatResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OllamaChatResponseDtoToJson(this);

  ChatResponseEntity toEntity() {
    return ChatResponseEntity(
      content: message?.content ?? '',
      toolCalls: (message?.toolCalls ?? [])
          .map((toolCall) => toolCall.toEntity())
          .toList(),
      promptEvalCount: promptEvalCount ?? 0,
      promptEvalCachedCount: promptEvalCachedCount ?? 0,
      evalCount: evalCount ?? 0,
    );
  }
}
