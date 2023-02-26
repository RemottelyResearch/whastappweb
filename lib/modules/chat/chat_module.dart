import 'package:flutter_modular/flutter_modular.dart';
import 'package:whatsappweb/core/domain/entities/user_entity.dart';
import 'package:whatsappweb/modules/chat/domain/usecases/remote_load_remetente_usecase_impl.dart';
import 'package:whatsappweb/modules/chat/external/datasources/chat_datasource_impl.dart';
import 'package:whatsappweb/modules/chat/infra/repositories/chat_repository_impl.dart';
import 'package:whatsappweb/modules/chat/presenter/controllers/chat_controller.dart';
import 'package:whatsappweb/modules/chat/presenter/pages/chat_page.dart';

class ChatModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.factory<ChatDatasourceImpl>((_) => ChatDatasourceImpl()),
        Bind.factory<ChatRepositoryImpl>(
            (_) => ChatRepositoryImpl(Modular.get<ChatDatasourceImpl>())),
        Bind.factory<RemoteLoadRemetenteUseCaseImpl>((_) =>
            RemoteLoadRemetenteUseCaseImpl(Modular.get<ChatRepositoryImpl>())),
        Bind.factory<ChatController>((_) => ChatController(
            remoteLoadRemetenteUseCase:
                Modular.get<RemoteLoadRemetenteUseCaseImpl>())),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (context, args) => ChatPage(args.data as UserEntity),
        ),
      ];
}
