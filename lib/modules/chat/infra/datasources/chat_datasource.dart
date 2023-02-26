import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsappweb/core/infra/models/user_model.dart';
import 'package:whatsappweb/modules/chat/infra/models/chat_model.dart';

abstract class ChatDatasource {
  UserModel? remoteFetchLoggedUserData();
  void remotePutChatStatus(ChatModel chat);
  Stream<QuerySnapshot<Map<String, dynamic>>> remoteSnapshotMessages({
    required String idLoggedUser,
    required String idRecipientUser,
  });
}
