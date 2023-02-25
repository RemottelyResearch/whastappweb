import 'package:flutter_modular/flutter_modular.dart';
import 'package:whatsappweb/core/domain/entities/user_entity.dart';
import 'package:whatsappweb/core/infra/repositories/chat_repository.dart';
import 'package:whatsappweb/modules/chat/presenter/pages/chat_page.dart';
import 'package:whatsappweb/modules/login/login_page.dart';

import 'home/home_page.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton<ChatRepository>((i) => ChatRepository()),
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
