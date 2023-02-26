import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsappweb/core/domain/entities/user_entity.dart';
import 'package:whatsappweb/modules/chat/domain/repositories/chat_repository.dart';
import 'package:whatsappweb/modules/chat/external/datasources/chat_datasource_impl.dart';
import 'package:whatsappweb/modules/chat/infra/models/chat_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatDatasourceImpl chatDatasource;

  const ChatRepositoryImpl(this.chatDatasource);

  UserEntity? remoteGetLoggedUserData() {
    return chatDatasource.remoteFetchLoggedUserData()?.toEntity();
  }

  void remoteSetChatStatus(ChatModel chat) {
    chatDatasource.remotePutChatStatus(chat);
    return;
  }

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
