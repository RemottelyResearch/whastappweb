import 'package:flutter_modular/flutter_modular.dart';
import 'package:whatsappweb/core/conversa_provider.dart';
import 'package:whatsappweb/core/usuario.dart';
import 'package:whatsappweb/modules/chat/mensagens_view.dart';
import 'package:whatsappweb/modules/login/login_view.dart';

import 'home/home_view.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton<ConversaProvider>((i) => ConversaProvider()),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (context, args) => const HomeView(),
        ),
        ChildRoute(
          '/login',
          child: (context, args) => const LoginView(),
        ),
        ChildRoute(
          '/mensagens',
          child: (context, args) => MensagensView(args.data as Usuario),
        ),
      ];
}
