import 'package:whatsappweb/core/domain/entities/user_entity.dart';

import '../../domain/usecases/remote_load_remetente_usecase.dart';

class ChatController {
  final RemoteLoadRemetenteUseCase remoteLoadRemetenteUseCase;

  ChatController({
    required this.remoteLoadRemetenteUseCase,
  });

  UserEntity? usuarioDestinatario;
  UserEntity? usuarioRemetente;

  recuperarDadosIniciais() {
    usuarioRemetente = remoteLoadRemetenteUseCase.call();
  }
}
