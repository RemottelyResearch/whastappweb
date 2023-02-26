import 'package:whatsappweb/core/domain/entities/user_entity.dart';
import 'package:whatsappweb/modules/chat/domain/repositories/chat_repository.dart';

class ChatController {
  final ChatRepository chatRepository;

  ChatController(this.chatRepository);

  UserEntity? usuarioDestinatario;
  UserEntity? usuarioRemetente;

  recuperarDadosIniciais() {
    usuarioRemetente = chatRepository.remoteGetRemetente();
  }
}
