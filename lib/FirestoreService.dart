import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> saveMessage(
      String userId,
      ChatMessage userMessage,
      ChatMessage botMessage,
      ) async {
    if (userId.isEmpty) return;
    final chatRef = _firestore.collection('chats').doc(userId).collection('messages');
    await chatRef.add({
      'userMessage': userMessage.toJson(),
      'botMessage': botMessage.toJson(),
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  static Stream<List<ChatMessage>> getMessages(String userId) {
    if (userId.isEmpty) return Stream.value([]);
    return _firestore
        .collection('chats')
        .doc(userId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
          List<ChatMessage> message = [];
          for(var doc in snapshot.docs){
            message.add(ChatMessage.fromJson(doc['userMessage']));
            message.add(ChatMessage.fromJson(doc['botMessage']));
          }
          return message.reversed.toList();
    });
  }
}
