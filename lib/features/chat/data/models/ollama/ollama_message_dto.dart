import 'package:fitness_app/features/chat/data/models/ollama/ollama_tool_dto.dart';
import 'package:fitness_app/features/chat/domain/entities/message_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ollama_message_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class OllamaMessageDto {
  final String role;
  final String content;

  @JsonKey(name: 'tool_calls', includeIfNull: false)
  final List<OllamaToolCallDto>? toolCalls;

  @JsonKey(name: 'tool_name', includeIfNull: false)
  final String? toolName;

  @JsonKey(name: 'tool_call_id', includeIfNull: false)
  final String? toolCallId;

  const OllamaMessageDto({
    required this.role,
    this.content = '',
    this.toolCalls,
    this.toolName,
    this.toolCallId,
  });

  const OllamaMessageDto.system(String prompt)
      : role = 'system',
        content = prompt,
        toolCalls = null,
        toolName = null,
        toolCallId = null;

  factory OllamaMessageDto.fromEntity(MessageEntity entity) {
    return OllamaMessageDto(
      role: entity.role,
      content: entity.content,
      toolCalls: entity.toolCalls
          .map(OllamaToolCallDto.fromEntity)
          .toList(),
      toolName: entity.toolName,
      toolCallId: entity.toolCallId,
    );
  }

  factory OllamaMessageDto.fromJson(Map<String, dynamic> json) =>
      _$OllamaMessageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OllamaMessageDtoToJson(this);
}
