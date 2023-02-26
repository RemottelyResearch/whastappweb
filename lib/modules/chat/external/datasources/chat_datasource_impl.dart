import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsappweb/core/infra/models/user_model.dart';
import 'package:whatsappweb/modules/chat/infra/datasources/chat_datasource.dart';

class ChatDatasourceImpl implements ChatDatasource {
  UserModel? remoteFetchRemetente() {
    FirebaseAuth _auth = FirebaseAuth.instance;

    User? usuarioLogado = _auth.currentUser;

    if (usuarioLogado == null) return null;

    String idUsuario = usuarioLogado.uid;
    String? nome = usuarioLogado.displayName ?? '';
    String? email = usuarioLogado.email ?? '';
    String? urlImagem = usuarioLogado.photoURL ?? '';

    return UserModel(
      idUsuario: idUsuario,
      nome: nome,
      email: email,
      urlImagem: urlImagem,
    );
  }
}
