import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsappweb/core/infra/models/user_model.dart';
import 'package:whatsappweb/modules/chat/infra/datasources/chat_datasource.dart';

class ChatDatasourceImpl implements ChatDatasource {
  final FirebaseAuth _auth;

  ChatDatasourceImpl(this._auth);

  UserModel? remoteFetchLoggedUserData() {
    User? _loggedUserData = _auth.currentUser;

    if (_loggedUserData == null) return null;

    return UserModel(
      idUsuario: _loggedUserData.uid,
      nome: _loggedUserData.displayName ?? '',
      email: _loggedUserData.email ?? '',
      urlImagem: _loggedUserData.photoURL ?? '',
    );
  }
}
