
import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  final String id;
  final String title;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? lastMessage;
  final int totalTokens;
  final bool isDeleted;

  const ChatEntity({
    required this.id,
    required this.title,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.lastMessage,
    this.totalTokens = 0,
    this.isDeleted = false,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        userId,
        createdAt,
        updatedAt,
        lastMessage,
        totalTokens,
        isDeleted,
      ];
}
