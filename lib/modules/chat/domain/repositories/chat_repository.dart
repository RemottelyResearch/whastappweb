import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsappweb/modules/chat/infra/models/chat_message_model.dart';
import 'package:whatsappweb/modules/chat/infra/models/chat_model.dart';

abstract class ChatRepository {
  Future<void> remotePutChatStatus(ChatModel chat);

  Future<void> putMessage({
    required String idLoggedUser,
    required String idRecipient,
    required ChatMessageModel message,
  });

  Stream<QuerySnapshot<Map<String, dynamic>>> remoteStreamMessages({
    required String idLoggedUser,
    required String idRecipientUser,
  });
}
