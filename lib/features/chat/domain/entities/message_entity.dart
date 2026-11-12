
import 'package:equatable/equatable.dart';
import 'package:fitness_app/features/chat/domain/entities/chat_tool_definition_entity.dart';

class MessageEntity extends Equatable {
  final String id;
  final String chatId;
  final String content;
  final String role;
  final DateTime createdAt;
  final String? toolName;
  final String? toolCallId;
  final List<ToolCallEntity> toolCalls;
  final List<String> exerciseIds;
  final List<String> mealIds;
  final int tokensUsed;

  const MessageEntity({
    required this.id,
    required this.chatId,
    required this.content,
    required this.role,
    required this.createdAt,
    this.toolName,
    this.toolCallId,
    this.toolCalls = const [],
    this.exerciseIds = const [],
    this.mealIds = const [],
    this.tokensUsed = 0,
  });

  @override
  List<Object?> get props => [
        id,
        chatId,
        content,
        role,
        createdAt,
        toolName,
        toolCallId,
        toolCalls,
        exerciseIds,
        mealIds,
        tokensUsed,
      ];
}
