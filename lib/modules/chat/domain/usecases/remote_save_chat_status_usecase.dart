import 'package:whatsappweb/modules/chat/domain/entities/chat_entity.dart';
import 'package:whatsappweb/modules/chat/domain/helpers/end_connection_status_type.dart';

abstract class RemoteSaveChatStatusUseCase {
  Future<EndConnectionStatusType> call(ChatEntity chat);
}
