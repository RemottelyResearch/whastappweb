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
    User? _loggedUserData = auth.currentUser;

    if (_loggedUserData == null) return null;

    return UserModel(
      idUsuario: _loggedUserData.uid,
      nome: _loggedUserData.displayName ?? '',
      email: _loggedUserData.email ?? '',
      urlImagem: _loggedUserData.photoURL ?? '',
    );
  }

  void remotePutChatStatus(ChatModel chat) {
    final _chatMap = chat.toMap();
    firestore
        .collection('conversas')
        .doc(chat.idRemetente)
        .collection('ultimas_mensagens')
        .doc(chat.idDestinatario)
        .set(_chatMap);
  }
}
