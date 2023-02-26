import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:whatsappweb/core/domain/entities/user_entity.dart';
import 'package:whatsappweb/modules/chat/domain/usecases/remote_load_logged_user_data_usecase_impl.dart';
import 'package:whatsappweb/modules/chat/domain/usecases/remote_save_chat_status_usecase_impl.dart';
import 'package:whatsappweb/modules/chat/domain/usecases/remote_stream_messages_usecase_impl.dart';
import 'package:whatsappweb/modules/chat/external/datasources/chat_datasource_impl.dart';
import 'package:whatsappweb/modules/chat/infra/repositories/chat_repository_impl.dart';
import 'package:whatsappweb/modules/chat/presenter/controllers/chat_controller.dart';
import 'package:whatsappweb/modules/chat/presenter/pages/chat_page.dart';

class ChatModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.factory<ChatDatasourceImpl>((_) => ChatDatasourceImpl(
            auth: Modular.get<FirebaseAuth>(),
            firestore: Modular.get<FirebaseFirestore>())),
        Bind.factory<ChatRepositoryImpl>(
            (_) => ChatRepositoryImpl(Modular.get<ChatDatasourceImpl>())),
        Bind.factory<RemoteLoadLoggedUserDataUseCaseImpl>((_) =>
            RemoteLoadLoggedUserDataUseCaseImpl(
                Modular.get<ChatRepositoryImpl>())),
        Bind.factory<RemoteSaveChatStatusUseCaseImpl>((_) =>
            RemoteSaveChatStatusUseCaseImpl(Modular.get<ChatRepositoryImpl>())),
        Bind.factory<RemoteStreamMessagesUseCaseImpl>((_) =>
            RemoteStreamMessagesUseCaseImpl(Modular.get<ChatRepositoryImpl>())),
        Bind.singleton<ChatController>((_) => ChatController(
              remoteLoadLoggedUserData:
                  Modular.get<RemoteLoadLoggedUserDataUseCaseImpl>(),
              remoteSaveChatStatus:
                  Modular.get<RemoteSaveChatStatusUseCaseImpl>(),
              remoteStreamMessages:
                  Modular.get<RemoteStreamMessagesUseCaseImpl>(),
            )),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (context, args) => ChatPage(args.data as UserEntity),
        ),
      ];
}
