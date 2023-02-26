import 'dart:developer';

import 'package:whatsappweb/core/domain/entities/user_entity.dart';
import 'package:whatsappweb/core/domain/usecases/remote_load_logged_user_data_usecase.dart';
import 'package:whatsappweb/core/infra/repositories/user_repository_impl.dart';

class RemoteLoadLoggedUserDataUseCaseImpl
    implements RemoteLoadLoggedUserDataUseCase {
  final UserRepositoryImpl chatRepository;

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
