import 'package:fitness_app/features/chat/domain/entities/chat_tool_definition_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ollama_tool_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class OllamaToolDto {
  final String type;
  final OllamaToolFunctionDto function;

  const OllamaToolDto({
    this.type = 'function',
    required this.function,
  });

  factory OllamaToolDto.fromEntity(ChatToolDefinitionEntity entity) {
    return OllamaToolDto(
      function: OllamaToolFunctionDto(
        name: entity.name,
        description: entity.description,
        parameters: entity.parameters,
      ),
    );
  }

  factory OllamaToolDto.fromJson(Map<String, dynamic> json) =>
      _$OllamaToolDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OllamaToolDtoToJson(this);
}

@JsonSerializable()
class OllamaToolFunctionDto {
  final String name;
  final String description;
  final Map<String, dynamic> parameters;

  const OllamaToolFunctionDto({
    required this.name,
    required this.description,
    required this.parameters,
  });

  factory OllamaToolFunctionDto.fromJson(Map<String, dynamic> json) =>
      _$OllamaToolFunctionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OllamaToolFunctionDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class OllamaToolCallDto {
  final String? id;
  final OllamaToolCallFunctionDto function;

  const OllamaToolCallDto({
    this.id,
    required this.function,
  });

  factory OllamaToolCallDto.fromEntity(ToolCallEntity entity) {
    return OllamaToolCallDto(
      id: entity.id,
      function: OllamaToolCallFunctionDto(
        name: entity.name,
        arguments: entity.arguments,
      ),
    );
  }

  ToolCallEntity toEntity() {
    return ToolCallEntity(
      id: id,
      name: function.name,
      arguments: function.arguments,
    );
  }

  factory OllamaToolCallDto.fromJson(Map<String, dynamic> json) =>
      _$OllamaToolCallDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OllamaToolCallDtoToJson(this);
}

@JsonSerializable()
class OllamaToolCallFunctionDto {
  final String name;
  final Map<String, dynamic> arguments;

  const OllamaToolCallFunctionDto({
    required this.name,
    required this.arguments,
  });

  factory OllamaToolCallFunctionDto.fromJson(Map<String, dynamic> json) =>
      _$OllamaToolCallFunctionDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$OllamaToolCallFunctionDtoToJson(this);
}
