import 'package:flutter_modular/flutter_modular.dart';
import 'package:whatsappweb/core/domain/entities/user_entity.dart';
import 'package:whatsappweb/modules/chat/infra/repositories/chat_repository_impl.dart';
import 'package:whatsappweb/modules/chat/presenter/controllers/chat_controller.dart';
import 'package:whatsappweb/modules/chat/presenter/pages/chat_page.dart';
import 'package:whatsappweb/modules/login/presenter/pages/login_page.dart';

import 'home/home_page.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.factory<ChatRepositoryImpl>((_) => ChatRepositoryImpl()),
        Bind.singleton<ChatController>(
            (_) => ChatController(Modular.get<ChatRepositoryImpl>())),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (context, args) => const HomePage(),
        ),
        ChildRoute(
          '/login',
          child: (context, args) => const LoginPage(),
        ),
        ChildRoute(
          '/mensagens',
          child: (context, args) => ChatPage(args.data as UserEntity),
        ),
      ];
}
