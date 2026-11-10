
import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String chatId;
  final String content;
  final String role;
  final DateTime createdAt;

  const MessageEntity({
    required this.id,
    required this.chatId,
    required this.content,
    required this.role,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        chatId,
        content,
        role,
        createdAt,
      ];
}
