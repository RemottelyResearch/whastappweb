import 'package:flutter_modular/flutter_modular.dart';
import 'package:whatsappweb/modelos/usuario.dart';
import 'package:whatsappweb/provider/conversa_provider.dart';
import 'package:whatsappweb/telas/home.dart';
import 'package:whatsappweb/telas/login.dart';
import 'package:whatsappweb/telas/mensagens.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton<ConversaProvider>((i) => ConversaProvider()),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (context, args) => const Login(),
        ),
        ChildRoute(
          '/login',
          child: (context, args) => const Login(),
        ),
        ChildRoute(
          '/home',
          child: (context, args) => const Home(),
        ),
        ChildRoute(
          '/mensagens',
          child: (context, args) => Mensagens(args.data as Usuario),
        ),
      ];
}
