import 'package:flutter_modular/flutter_modular.dart';

import 'presenter/controllers/sign_up_controller.dart';
import 'presenter/pages/sign_up_page.dart';

class SignUpModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton<SignUpController>((_) => SignUpController()),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (context, args) => SignUpPage(),
        ),
      ];
}
