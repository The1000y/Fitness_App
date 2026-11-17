// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ollama_chat_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OllamaChatResponseDto _$OllamaChatResponseDtoFromJson(
  Map<String, dynamic> json,
) => OllamaChatResponseDto(
  model: json['model'] as String?,
  message: json['message'] == null
      ? null
      : OllamaMessageDto.fromJson(json['message'] as Map<String, dynamic>),
  done: json['done'] as bool?,
  promptEvalCount: (json['prompt_eval_count'] as num?)?.toInt(),
  promptEvalCachedCount: (json['prompt_eval_cached_count'] as num?)?.toInt(),
  evalCount: (json['eval_count'] as num?)?.toInt(),
);

Map<String, dynamic> _$OllamaChatResponseDtoToJson(
  OllamaChatResponseDto instance,
) => <String, dynamic>{
  'model': instance.model,
  'message': instance.message?.toJson(),
  'done': instance.done,
  'prompt_eval_count': instance.promptEvalCount,
  'prompt_eval_cached_count': instance.promptEvalCachedCount,
  'eval_count': instance.evalCount,
};
