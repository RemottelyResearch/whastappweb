import 'package:flutter_modular/flutter_modular.dart';
import 'package:whatsappweb/modules/login/presenter/pages/login_page.dart';

import 'chat/chat_module.dart';
import 'home/home_page.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [];

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
        ModuleRoute<ChatModule>(
          '/chat',
          module: ChatModule(),
        ),
      ];
}
