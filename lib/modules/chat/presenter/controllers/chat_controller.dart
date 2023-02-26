import 'package:whatsappweb/core/domain/entities/user_entity.dart';
import 'package:whatsappweb/modules/chat/domain/repositories/interface_chat_repository.dart';

class ChatController {
  final InterfaceChatRepository chatRepository;

  ChatController(this.chatRepository);

  UserEntity? usuarioDestinatario;
  UserEntity? usuarioRemetente;

  recuperarDadosIniciais() {
    usuarioRemetente = chatRepository.getRemetente();
  }
}
