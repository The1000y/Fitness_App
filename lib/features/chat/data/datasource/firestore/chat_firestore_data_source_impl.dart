
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/features/chat/data/datasource/firestore/chat_firestore_data_source.dart';
import 'package:fitness_app/features/chat/data/models/firestore/chat_message_model.dart';
import 'package:fitness_app/features/chat/data/models/firestore/chat_model.dart';
import 'package:fitness_app/features/chat/data/models/firestore/chat_page_model.dart';
import 'package:fitness_app/features/chat/domain/entities/chat_tool_definition_entity.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ChatFirestoreDataSource)
class ChatFirestoreDataSourceImpl implements ChatFirestoreDataSource {
  final FirebaseFirestore _firestore;

  ChatFirestoreDataSourceImpl(this._firestore);

  CollectionReference<ChatModel> get _chatsCollection {
    return _firestore.collection('chats').withConverter<ChatModel>(
      fromFirestore: ChatModel.fromFirestore,
      toFirestore: (chat, options) => chat.toFirestore(),
    );
  }

  CollectionReference<ChatMessageModel> _messagesCollection(String chatId) {
    return _chatsCollection.doc(chatId).collection('messages')
        .withConverter<ChatMessageModel>(
      fromFirestore: ChatMessageModel.fromFirestore,
      toFirestore: (message, options) => message.toFirestore(),
    );
  }

  @override
  Future<ChatModel> createChat({
    required String title,
    required String userId,

  }) async {
    final now = DateTime.now();
    final chatDocument = _chatsCollection.doc();

    final chat = ChatModel(
      id: chatDocument.id,
      title: title,
      userId: userId,
      createdAt: now,
      updatedAt: now,
      totalTokens: 0,
      isDeleted: false,
    );

    await chatDocument.set(chat);

    return chat;
  }

 
@override
Future<ChatPageModel> getChats({
  required String userId,
  int limit = 20,
  DateTime? startAfterUpdatedAt,
  String? startAfterId,
}) async {
  Query<ChatModel> query = _chatsCollection
      .where('userId', isEqualTo: userId)
      .where('isDeleted', isEqualTo: false)
      .orderBy('updatedAt', descending: true)
      .orderBy(FieldPath.documentId)
      .limit(limit + 1);

  if (startAfterUpdatedAt != null && startAfterId != null) {
    query = query.startAfter([
      Timestamp.fromDate(startAfterUpdatedAt),
      startAfterId,
    ]);
  }

  final snapshot = await query.get();

  final hasMore = snapshot.docs.length > limit;

  final pageDocs = hasMore
      ? snapshot.docs.take(limit).toList()
      : snapshot.docs;

  final chats = pageDocs.map((doc) => doc.data()).toList();

  return ChatPageModel(
    chats: chats,
    hasMore: hasMore,
  );
}


  @override
  Future<void> deleteChat({
    required String chatId,
  }) async {
    final chatDocument = _chatsCollection.doc(chatId);
    final deletedAt = DateTime.now();

    await chatDocument.update({
      'isDeleted': true,
      'deletedAt': Timestamp.fromDate(deletedAt),
      'updatedAt': Timestamp.fromDate(deletedAt),
    });

    final messagesSnapshot = await _messagesCollection(chatId).get();

    for (var i = 0; i < messagesSnapshot.docs.length; i += 500) {
      final batch = _firestore.batch();

      final end = (i + 500 < messagesSnapshot.docs.length)
          ? i + 500
          : messagesSnapshot.docs.length;

      for (var j = i; j < end; j++) {
        batch.delete(messagesSnapshot.docs[j].reference);
      }

      await batch.commit();
    }

    await chatDocument.delete();
  }

  @override
  Future<ChatMessageModel> saveMessage({
    required String chatId,
    String? messageId,
    required String content,
    required String role,
    String? toolName,
    String? toolCallId,
    List<ToolCallEntity> toolCalls = const [],
    List<String> exerciseIds = const [],
    List<String> mealIds = const [],
    int tokensUsed = 0,
  }) async {
    final now = DateTime.now();
    final normalizedMessageId = messageId?.trim();
    final messageDocument = normalizedMessageId == null ||
            normalizedMessageId.isEmpty
        ? _messagesCollection(chatId).doc()
        : _messagesCollection(chatId).doc(normalizedMessageId);
    final message = ChatMessageModel(
      id: messageDocument.id,
      content: content,
      role: role,
      createdAt: now,
      toolName: toolName,
      toolCallId: toolCallId,
      toolCalls: toolCalls,
      exerciseIds: exerciseIds,
      mealIds: mealIds,
      tokensUsed: tokensUsed,
    );
    final batch = _firestore.batch();

    batch.set(messageDocument, message);
    batch.update(_chatsCollection.doc(chatId), {
      'updatedAt': Timestamp.fromDate(now),
      'lastMessage': content,
      'totalTokens': FieldValue.increment(tokensUsed),
    });

    await batch.commit();
    return message;
  }

  @override
  Future<List<ChatMessageModel>> getChatHistory({
    required String chatId,
    int limit = 50,
    DateTime? startAfter,
  }) async {
    Query<ChatMessageModel> query = _messagesCollection(chatId)
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (startAfter != null) {
      query = query.startAfter([Timestamp.fromDate(startAfter)]);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
