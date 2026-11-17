// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ollama_tool_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OllamaToolDto _$OllamaToolDtoFromJson(Map<String, dynamic> json) =>
    OllamaToolDto(
      type: json['type'] as String? ?? 'function',
      function: OllamaToolFunctionDto.fromJson(
        json['function'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$OllamaToolDtoToJson(OllamaToolDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'function': instance.function.toJson(),
    };

OllamaToolFunctionDto _$OllamaToolFunctionDtoFromJson(
  Map<String, dynamic> json,
) => OllamaToolFunctionDto(
  name: json['name'] as String,
  description: json['description'] as String,
  parameters: json['parameters'] as Map<String, dynamic>,
);

Map<String, dynamic> _$OllamaToolFunctionDtoToJson(
  OllamaToolFunctionDto instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'parameters': instance.parameters,
};

OllamaToolCallDto _$OllamaToolCallDtoFromJson(Map<String, dynamic> json) =>
    OllamaToolCallDto(
      id: json['id'] as String?,
      function: OllamaToolCallFunctionDto.fromJson(
        json['function'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$OllamaToolCallDtoToJson(OllamaToolCallDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'function': instance.function.toJson(),
    };

OllamaToolCallFunctionDto _$OllamaToolCallFunctionDtoFromJson(
  Map<String, dynamic> json,
) => OllamaToolCallFunctionDto(
  name: json['name'] as String,
  arguments: json['arguments'] as Map<String, dynamic>,
);

Map<String, dynamic> _$OllamaToolCallFunctionDtoToJson(
  OllamaToolCallFunctionDto instance,
) => <String, dynamic>{'name': instance.name, 'arguments': instance.arguments};
