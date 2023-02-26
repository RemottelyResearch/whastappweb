import 'package:whatsappweb/core/domain/entities/user_entity.dart';
import 'package:whatsappweb/modules/chat/domain/repositories/chat_repository.dart';
import 'package:whatsappweb/modules/chat/external/datasources/chat_datasource_impl.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatDatasourceImpl chatDatasource;

  const ChatRepositoryImpl(this.chatDatasource);

  UserEntity? remoteGetLoggedUserData() {
    return chatDatasource.remoteFetchLoggedUserData()?.toEntity();
  }
}
