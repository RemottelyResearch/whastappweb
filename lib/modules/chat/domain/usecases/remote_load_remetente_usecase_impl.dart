import 'dart:developer';

import 'package:whatsappweb/core/domain/entities/user_entity.dart';
import 'package:whatsappweb/modules/chat/domain/usecases/chat_repository.dart';
import 'package:whatsappweb/modules/chat/infra/repositories/chat_repository_impl.dart';

class RemoteLoadRemetentUseCaseImpl implements RemoteLoadRemetenteUseCase {
  final ChatRepositoryImpl chatRepository;

  const RemoteLoadRemetentUseCaseImpl(this.chatRepository);

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
