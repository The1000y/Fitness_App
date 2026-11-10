import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/features/chat/domain/entities/message_entity.dart';

class MessageModel {
  final String id;
  final String content;
  final String role;
  final DateTime createdAt;

  const MessageModel({
    required this.id,
    required this.content,
    required this.role,
    required this.createdAt,
  });

  factory MessageModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;

    return MessageModel(
      id: snapshot.id,
      content: data['content'] as String,
      role: data['role'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'content': content,
      'role': role,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  MessageEntity toEntity({required String chatId}) {
    return MessageEntity(
      id: id,
      chatId: chatId,
      content: content,
      role: role,
      createdAt: createdAt,
    );
  }
}