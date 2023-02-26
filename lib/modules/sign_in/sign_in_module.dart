import 'package:flutter_modular/flutter_modular.dart';
import 'package:whatsappweb/modules/sign_in/presenter/pages/sign_in_page.dart';

import 'presenter/controllers/sign_in_controller.dart';

class SignInModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton<SignInController>((_) => SignInController()),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (context, args) => SignInPage(),
        ),
      ];
}
