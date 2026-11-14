
import 'package:equatable/equatable.dart';
import 'package:fitness_app/features/chat/domain/entities/chat_tool_definition_entity.dart';

class ChatResponseEntity extends Equatable {
  final String content;
  final List<ToolCallEntity> toolCalls;
  final int promptEvalCount;
  final int promptEvalCachedCount;
  final int evalCount;

  const ChatResponseEntity({
    required this.content,
    this.toolCalls = const [],
    this.promptEvalCount = 0,
    this.promptEvalCachedCount = 0,
    this.evalCount = 0,
  });

  int get totalTokensUsed => promptEvalCount + evalCount;

  bool get hasToolCalls => toolCalls.isNotEmpty;

  @override
  List<Object?> get props => [
        content,
        toolCalls,
        promptEvalCount,
        promptEvalCachedCount,
        evalCount,
      ];
}
