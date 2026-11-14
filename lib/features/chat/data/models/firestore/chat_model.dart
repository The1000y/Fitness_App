
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/features/chat/domain/entities/chat_entity.dart';

class ChatModel {
  final String id;
  final String title;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? lastMessage;
  final int totalTokens;
  final bool isDeleted;
  final DateTime? deletedAt;

  const ChatModel({
    required this.id,
    required this.title,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.lastMessage,
    this.totalTokens = 0,
    this.isDeleted = false,
    this.deletedAt,
  });

  factory ChatModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;

    return ChatModel(
      id: snapshot.id,
      title: data['title'] as String,
      userId: data['userId'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      lastMessage: data['lastMessage'] as String?,
      totalTokens: (data['totalTokens'] as num?)?.toInt() ?? 0,
      isDeleted: data['isDeleted'] as bool? ?? false,
      deletedAt: (data['deletedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'userId': userId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'lastMessage': lastMessage,
      'totalTokens': totalTokens,
      'isDeleted': isDeleted,
      'deletedAt': deletedAt == null ? null : Timestamp.fromDate(deletedAt!),
    };
  }

  ChatEntity toEntity() {
    return ChatEntity(
      id: id,
      title: title,
      userId: userId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      lastMessage: lastMessage,
      totalTokens: totalTokens,
      isDeleted: isDeleted,
    );
  }
}
