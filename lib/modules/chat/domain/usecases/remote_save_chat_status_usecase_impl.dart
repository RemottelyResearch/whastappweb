import 'dart:developer';

import 'package:whatsappweb/modules/chat/domain/entities/chat_entity.dart';
import 'package:whatsappweb/modules/chat/domain/helpers/end_connection_status_type.dart';
import 'package:whatsappweb/modules/chat/domain/usecases/remote_save_chat_status_usecase.dart';
import 'package:whatsappweb/modules/chat/infra/models/chat_model.dart';
import 'package:whatsappweb/modules/chat/infra/repositories/chat_repository_impl.dart';

class RemoteSaveChatStatusUseCaseImpl implements RemoteSaveChatStatusUseCase {
  final ChatRepositoryImpl chatRepository;

  const RemoteSaveChatStatusUseCaseImpl(this.chatRepository);

  EndConnectionStatusType call(ChatEntity chat) {
    try {
      chatRepository.remotePutChatStatus(ChatModel.fromEntity(chat));

      return EndConnectionStatusType.successed;
    } catch (error) {
      log('[ERROR ON: RemoteSaveChatStatusUseCaseImpl]' + error.toString());
    }
    return EndConnectionStatusType.failed;
  }
}
