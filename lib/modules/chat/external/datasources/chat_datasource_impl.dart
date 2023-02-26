import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsappweb/core/infra/models/user_model.dart';
import 'package:whatsappweb/modules/chat/infra/datasources/chat_datasource.dart';
import 'package:whatsappweb/modules/chat/infra/models/chat_model.dart';

class ChatDatasourceImpl implements ChatDatasource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  ChatDatasourceImpl({
    required this.auth,
    required this.firestore,
  });

  UserModel? remoteFetchLoggedUserData() {
    User? loggedUserData = auth.currentUser;

    if (loggedUserData == null) return null;

    return UserModel(
      idUsuario: loggedUserData.uid,
      nome: loggedUserData.displayName ?? '',
      email: loggedUserData.email ?? '',
      urlImagem: loggedUserData.photoURL ?? '',
    );
  }

  void remotePutChatStatus(ChatModel chat) {
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
