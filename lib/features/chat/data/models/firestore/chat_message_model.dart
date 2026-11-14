import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/features/chat/domain/entities/chat_tool_definition_entity.dart';
import 'package:fitness_app/features/chat/domain/entities/message_entity.dart';

class ChatMessageModel {
  final String id;
  final String content;
  final String role;
  final DateTime createdAt;
  final String? toolName;
  final String? toolCallId;
  final List<ToolCallEntity> toolCalls;
  final List<String> exerciseIds;
  final List<String> mealIds;
  final int tokensUsed;

  const ChatMessageModel({
    required this.id,
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

  factory ChatMessageModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data() ?? const {};

    return ChatMessageModel(
      id: snapshot.id,
      content: data['content'] as String? ?? '',
      role: data['role'] as String? ?? 'user',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      toolName: data['toolName'] as String?,
      toolCallId: data['toolCallId'] as String?,
      toolCalls: (data['toolCalls'] as List? ?? const [])
          .whereType<Map>()
          .map((toolCall) => ToolCallEntity.fromJson(
                Map<String, dynamic>.from(toolCall),
              ))
          .toList(),
      exerciseIds: (data['exerciseIds'] as List? ?? const [])
          .map((id) => id.toString())
          .toList(),
      mealIds: (data['mealIds'] as List? ?? const [])
          .map((id) => id.toString())
          .toList(),
      tokensUsed: (data['tokensUsed'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'content': content,
      'role': role,
      'createdAt': Timestamp.fromDate(createdAt),
      'toolName': toolName,
      'toolCallId': toolCallId,
      'toolCalls': toolCalls.map((toolCall) => toolCall.toJson()).toList(),
      'exerciseIds': exerciseIds,
      'mealIds': mealIds,
      'tokensUsed': tokensUsed,
    };
  }

  MessageEntity toEntity({required String chatId}) {
    return MessageEntity(
      id: id,
      chatId: chatId,
      content: content,
      role: role,
      createdAt: createdAt,
      toolName: toolName,
      toolCallId: toolCallId,
      toolCalls: toolCalls,
      exerciseIds: exerciseIds,
      mealIds: mealIds,
      tokensUsed: tokensUsed,
    );
  }
}
