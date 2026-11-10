
import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? lastMessage;

  const ChatEntity({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.lastMessage,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        createdAt,
        updatedAt,
        lastMessage,
      ];
}
