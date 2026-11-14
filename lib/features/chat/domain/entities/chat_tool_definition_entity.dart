import 'package:equatable/equatable.dart';

class ChatToolDefinitionEntity extends Equatable {
  final String name;
  final String description;
  final Map<String, dynamic> parameters;

  const ChatToolDefinitionEntity({
    required this.name,
    required this.description,
    required this.parameters,
  });

  @override
  List<Object?> get props => [name, description, parameters];
}

class ToolCallEntity extends Equatable {
  final String name;
  final Map<String, dynamic> arguments;
  final String? id;

  const ToolCallEntity({
    required this.name,
    required this.arguments,
    this.id,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'function': {
          'name': name,
          'arguments': arguments,
        },
      };

  factory ToolCallEntity.fromJson(Map<String, dynamic> json) {
    final function = Map<String, dynamic>.from(
      json['function'] as Map? ?? const {},
    );

    return ToolCallEntity(
      id: json['id'] as String?,
      name: function['name'] as String? ?? '',
      arguments: Map<String, dynamic>.from(
        function['arguments'] as Map? ?? const {},
      ),
    );
  }

  @override
  List<Object?> get props => [name, arguments, id];
}
