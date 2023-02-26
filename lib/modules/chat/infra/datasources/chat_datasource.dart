import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsappweb/modules/chat/infra/models/chat_model.dart';

abstract class ChatDatasource {
  void remoteSetChatStatus(ChatModel chat);
  Stream<QuerySnapshot<Map<String, dynamic>>> remoteSnapshotMessages({
    required String idLoggedUser,
    required String idRecipientUser,
  });
}
