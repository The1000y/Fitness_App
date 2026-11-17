// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ollama_message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OllamaMessageDto _$OllamaMessageDtoFromJson(Map<String, dynamic> json) =>
    OllamaMessageDto(
      role: json['role'] as String,
      content: json['content'] as String? ?? '',
      toolCalls: (json['tool_calls'] as List<dynamic>?)
          ?.map((e) => OllamaToolCallDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      toolName: json['tool_name'] as String?,
      toolCallId: json['tool_call_id'] as String?,
    );

Map<String, dynamic> _$OllamaMessageDtoToJson(OllamaMessageDto instance) =>
    <String, dynamic>{
      'role': instance.role,
      'content': instance.content,
      'tool_calls': ?instance.toolCalls?.map((e) => e.toJson()).toList(),
      'tool_name': ?instance.toolName,
      'tool_call_id': ?instance.toolCallId,
    };
