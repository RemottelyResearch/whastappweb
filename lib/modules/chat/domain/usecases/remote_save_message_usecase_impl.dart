import 'dart:async';
import 'dart:developer';

import 'package:whatsappweb/modules/chat/domain/entities/chat_message_entity.dart';
import 'package:whatsappweb/modules/chat/domain/helpers/end_connection_status_type.dart';
import 'package:whatsappweb/modules/chat/domain/repositories/chat_repository.dart';
import 'package:whatsappweb/modules/chat/domain/usecases/remote_save_message_usecase.dart';
import 'package:whatsappweb/modules/chat/infra/models/chat_message_model.dart';

class RemoteSaveMessageUseCaseImpl implements RemoteSaveMessageUseCase {
  final ChatRepository chatRepository;

  RemoteSaveMessageUseCaseImpl({required this.chatRepository});

  @override
  Future<EndConnectionStatusType> call(
      {required String idLoggedUser,
      required String idRecipient,
      required ChatMessageEntity message}) async {
    try {
      await chatRepository.putMessage(
        idLoggedUser: idLoggedUser,
        idRecipient: idRecipient,
        message: ChatMessageModel.fromEntity(message),
      );
      return EndConnectionStatusType.successed;
    } catch (error) {
      log('[ERROR ON: RemoteSaveMessageUseCaseImpl]' + error.toString());
      return EndConnectionStatusType.failed;
    }
  }
}
