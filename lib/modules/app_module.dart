import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:whatsappweb/modules/login/login_module.dart';

import 'chat/chat_module.dart';
import 'home/home_page.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.factory<FirebaseAuth>((_) => FirebaseAuth.instance),
        Bind.factory<FirebaseFirestore>((_) => FirebaseFirestore.instance),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (context, args) => const HomePage(),
        ),
        ModuleRoute<LoginModule>(
          '/login',
          module: LoginModule(),
        ),
        ModuleRoute<ChatModule>(
          '/chat',
          module: ChatModule(),
        ),
      ];
}
