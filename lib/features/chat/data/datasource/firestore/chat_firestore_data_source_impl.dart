
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/features/chat/data/datasource/firestore/chat_firestore_data_source.dart';
import 'package:fitness_app/features/chat/data/models/firestore/chat_model.dart';
import 'package:fitness_app/features/chat/data/models/firestore/message_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ChatFirestoreDataSource)
class ChatFirestoreDataSourceImpl implements ChatFirestoreDataSource {
  final FirebaseFirestore _firestore;

  ChatFirestoreDataSourceImpl(this._firestore);

  CollectionReference<ChatModel> get _chatsCollection {
    return _firestore.collection('chats').withConverter<ChatModel>(
      fromFirestore: ChatModel.fromFirestore,
      toFirestore: (chat, options) => chat.toFirestore(),
    );
  }

  CollectionReference<MessageModel> _messagesCollection(String chatId) {
    return _chatsCollection.doc(chatId).collection('messages')
        .withConverter<MessageModel>(
      fromFirestore: MessageModel.fromFirestore,
      toFirestore: (message, options) => message.toFirestore(),
    );
  }

  @override
  Future<ChatModel> createChat({
    required String title,
  }) async {
    final now = DateTime.now();
    final chatDocument = _chatsCollection.doc();

    final chat = ChatModel(
      id: chatDocument.id,
      title: title,
      createdAt: now,
      updatedAt: now,
    );

    await chatDocument.set(chat);

    return chat;
  }

  @override
  Future<List<ChatModel>> getChats() async {
    final snapshot = await _chatsCollection
        .orderBy('updatedAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Future<void> deleteChat({
    required String chatId,
  }) async {
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

    await _chatsCollection.doc(chatId).delete();
  }

  @override
Future<MessageModel> saveMessage({
  required String chatId,
  String? messageId,
  required String content,
  required String role,
}) async {
  final now = DateTime.now();

  final messageDocument = messageId == null
      ? _messagesCollection(chatId).doc()
      : _messagesCollection(chatId).doc(messageId);

  final message = MessageModel(
    id: messageDocument.id,
    content: content,
    role: role,
    createdAt: now,
  );

  final chatDocument = _chatsCollection.doc(chatId);

  final batch = _firestore.batch();

  batch.set(messageDocument, message);

  batch.update(chatDocument, {
    'updatedAt': Timestamp.fromDate(now),
    'lastMessage': content,
  });

  await batch.commit();

  return message;
}

  @override
Future<List<MessageModel>> getChatHistory({
  required String chatId,
}) async {
  final snapshot = await _messagesCollection(chatId)
      .orderBy('createdAt')
      .get();

  return snapshot.docs.map((doc) => doc.data()).toList();
}
}
