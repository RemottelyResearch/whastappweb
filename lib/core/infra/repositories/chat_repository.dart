import 'package:whatsappweb/core/domain/entities/user_entity.dart';
import 'package:whatsappweb/core/domain/repositories/i_chat_repository.dart';

class ChatRepository implements IChatRepository {
  UserEntity? _usuarioDestinatario;

  UserEntity? get usuarioDestinatario => _usuarioDestinatario;

  set usuarioDestinatario(UserEntity? usuario) {
    _usuarioDestinatario = usuario;
  }
}
