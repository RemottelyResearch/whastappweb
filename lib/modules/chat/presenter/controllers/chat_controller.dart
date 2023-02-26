import 'package:whatsappweb/core/domain/entities/user_entity.dart';

import '../../domain/usecases/remote_load_remetente_usecase.dart';

class ChatController {
  final RemoteLoadRemetenteUseCase remoteLoadRemetentUseCase;

  ChatController({
    required this.remoteLoadRemetentUseCase,
  });

  UserEntity? usuarioDestinatario;
  UserEntity? usuarioRemetente;

  recuperarDadosIniciais() {
    usuarioRemetente = remoteLoadRemetentUseCase.call();
  }
}
