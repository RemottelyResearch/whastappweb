import 'package:whatsappweb/modules/chat/domain/entities/chat_message_entity.dart';
import 'package:whatsappweb/modules/chat/domain/helpers/end_connection_status_type.dart';

abstract class RemoteSaveMessageUseCase {
  Future<EndConnectionStatusType> call({
    required String idLoggedUser,
    required String idRecipient,
    required ChatMessageEntity message,
  });
}
