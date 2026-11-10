
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/features/chat/domain/entities/chat_entity.dart';

class ChatModel {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? lastMessage;

  const ChatModel({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.lastMessage,
  });

  factory ChatModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;

    return ChatModel(
      id: snapshot.id,
      title: data['title'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      lastMessage: data['lastMessage'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'lastMessage': lastMessage,
    };
  }

  ChatEntity toEntity() {
    return ChatEntity(
      id: id,
      title: title,
      createdAt: createdAt,
      updatedAt: updatedAt,
      lastMessage: lastMessage,
    );
  }
}
