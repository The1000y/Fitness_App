// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ollama_chat_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OllamaChatRequestDto _$OllamaChatRequestDtoFromJson(
  Map<String, dynamic> json,
) => OllamaChatRequestDto(
  model: json['model'] as String,
  messages: (json['messages'] as List<dynamic>)
      .map((e) => OllamaMessageDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  stream: json['stream'] as bool,
  think: json['think'] as bool,
  tools: (json['tools'] as List<dynamic>?)
      ?.map((e) => OllamaToolDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  format: json['format'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$OllamaChatRequestDtoToJson(
  OllamaChatRequestDto instance,
) => <String, dynamic>{
  'model': instance.model,
  'messages': instance.messages.map((e) => e.toJson()).toList(),
  'stream': instance.stream,
  'think': instance.think,
  'tools': ?instance.tools?.map((e) => e.toJson()).toList(),
  'format': ?instance.format,
};
