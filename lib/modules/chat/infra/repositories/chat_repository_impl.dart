import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsappweb/modules/chat/domain/repositories/chat_repository.dart';
import 'package:whatsappweb/modules/chat/external/datasources/chat_datasource_impl.dart';
import 'package:whatsappweb/modules/chat/infra/models/chat_message_model.dart';
import 'package:whatsappweb/modules/chat/infra/models/chat_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatDatasourceImpl chatDatasource;

  const ChatRepositoryImpl(this.chatDatasource);

  @override
  Future<void> remotePutChatStatus(ChatModel chat) async {
    await chatDatasource.remoteSetChatStatus(chat);
    return;
  }

  @override
  Future<void> putMessage({
    required String idLoggedUser,
    required String idRecipient,
    required ChatMessageModel message,
  }) async {
    return await chatDatasource.addMessage(
      idLoggedUser: idLoggedUser,
      idRecipient: idRecipient,
      message: message,
    );
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> remoteStreamMessages({
    required String idLoggedUser,
    required String idRecipientUser,
  }) {
    return chatDatasource.remoteSnapshotMessages(
      idLoggedUser: idLoggedUser,
      idRecipientUser: idRecipientUser,
    );
  }
}
