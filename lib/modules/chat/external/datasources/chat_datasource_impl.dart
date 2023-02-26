import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsappweb/modules/chat/infra/datasources/chat_datasource.dart';
import 'package:whatsappweb/modules/chat/infra/models/chat_model.dart';

class ChatDatasourceImpl implements ChatDatasource {
  final FirebaseFirestore firestore;

  ChatDatasourceImpl({
    required this.firestore,
  });

  void remoteSetChatStatus(ChatModel chat) {
    final chatMap = chat.toMap();
    firestore
        .collection('conversas')
        .doc(chat.idRemetente)
        .collection('ultimas_mensagens')
        .doc(chat.idDestinatario)
        .set(chatMap);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> remoteSnapshotMessages({
    required String idLoggedUser,
    required String idRecipientUser,
  }) {
    return firestore
        .collection('mensagens')
        .doc(idLoggedUser)
        .collection(idRecipientUser)
        .orderBy('data', descending: true)
        .snapshots();
  }
}
