import 'dart:developer';

import 'package:whatsappweb/core/domain/entities/user_entity.dart';
import 'package:whatsappweb/modules/chat/domain/usecases/remote_load_remetente_usecase.dart';
import 'package:whatsappweb/modules/chat/infra/repositories/chat_repository_impl.dart';

class RemoteLoadRemetenteUseCaseImpl implements RemoteLoadRemetenteUseCase {
  final ChatRepositoryImpl chatRepository;

  const RemoteLoadRemetenteUseCaseImpl(this.chatRepository);

  UserEntity? call() {
    try {
      UserEntity? user = chatRepository.remoteGetRemetente();

      return user;
    } catch (error) {
      log('[ERROR ON: GetRemoteRemetentUseCaseImpl]' + error.toString());
    }
    return null;
  }
}
