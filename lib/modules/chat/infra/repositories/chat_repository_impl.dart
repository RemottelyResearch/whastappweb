import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsappweb/core/domain/entities/user_entity.dart';
import 'package:whatsappweb/modules/chat/domain/repositories/interface_chat_repository.dart';

class ChatRepositoryImpl implements InterfaceChatRepository {
  UserEntity? getRemetente() {
    FirebaseAuth _auth = FirebaseAuth.instance;

    User? usuarioLogado = _auth.currentUser;

    if (usuarioLogado == null) return null;

    String idUsuario = usuarioLogado.uid;
    String? nome = usuarioLogado.displayName ?? "";
    String? email = usuarioLogado.email ?? "";
    String? urlImagem = usuarioLogado.photoURL ?? "";

    return UserEntity(
      idUsuario: idUsuario,
      nome: nome,
      email: email,
      urlImagem: urlImagem,
    );
  }
}
