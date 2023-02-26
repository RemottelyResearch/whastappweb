import 'package:whatsappweb/core/infra/models/user_model.dart';
import 'package:whatsappweb/modules/chat/infra/models/chat_model.dart';

abstract class ChatDatasource {
  UserModel? remoteFetchLoggedUserData();
  void remotePutChatStatus(ChatModel chat);
}
