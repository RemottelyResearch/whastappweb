import 'dart:developer';

import 'package:whatsappweb/core/domain/entities/user_entity.dart';
import 'package:whatsappweb/modules/chat/domain/usecases/remote_load_remetente_usecase.dart';
import 'package:whatsappweb/modules/chat/infra/repositories/chat_repository_impl.dart';

class RemoteLoadLoggedUserDataUseCaseImpl
    implements RemoteLoadLoggedUserDataUseCase {
  final ChatRepositoryImpl chatRepository;

  const RemoteLoadLoggedUserDataUseCaseImpl(this.chatRepository);

  UserEntity? call() {
    try {
      UserEntity? user = chatRepository.remoteGetLoggedUserData();

      return user;
    } catch (error) {
      log('[ERROR ON: RemoteLoadLoggedUserDataUseCaseImpl]' + error.toString());
    }
    return null;
  }
}
