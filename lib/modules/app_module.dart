import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:whatsappweb/core/domain/usecases/remote_load_logged_user_data_usecase_impl.dart';
import 'package:whatsappweb/core/external/datasources/user_datasource_impl.dart';
import 'package:whatsappweb/core/infra/repositories/user_repository_impl.dart';
import 'package:whatsappweb/modules/sign_in/sign_in_module.dart';
import 'package:whatsappweb/modules/sign_up/sign_up_module.dart';

import 'chat/chat_module.dart';
import 'home/home_page.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.factory<FirebaseAuth>((_) => FirebaseAuth.instance),
        Bind.factory<FirebaseFirestore>((_) => FirebaseFirestore.instance),
        Bind.factory<UserDatasourceImpl>((_) => UserDatasourceImpl(
            auth: Modular.get<FirebaseAuth>(),
            firestore: Modular.get<FirebaseFirestore>())),
        Bind.factory<UserRepositoryImpl>(
            (_) => UserRepositoryImpl(Modular.get<UserDatasourceImpl>())),
        Bind.factory<RemoteLoadLoggedUserDataUseCaseImpl>((_) =>
            RemoteLoadLoggedUserDataUseCaseImpl(
                Modular.get<UserRepositoryImpl>())),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (context, args) => const HomePage(),
        ),
        ModuleRoute(
          '/sign-in',
          module: SignInModule(),
        ),
        ModuleRoute(
          '/sign-up',
          module: SignUpModule(),
        ),
        ModuleRoute(
          '/chat',
          module: ChatModule(),
        ),
      ];
}
