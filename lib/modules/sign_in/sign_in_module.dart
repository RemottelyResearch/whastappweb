import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:whatsappweb/modules/sign_in/domain/usecases/remote_login_with_email_and_password_usecase_impl.dart';
import 'package:whatsappweb/modules/sign_in/external/datasources/sign_in_datasource_impl.dart';
import 'package:whatsappweb/modules/sign_in/infra/repositories/sign_in_repository_impl.dart';
import 'package:whatsappweb/modules/sign_in/presenter/pages/sign_in_page.dart';

import 'presenter/controllers/sign_in_controller.dart';

class SignInModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton<SignInDatasourceImpl>(
            (_) => SignInDatasourceImpl(auth: Modular.get<FirebaseAuth>())),
        Bind.singleton<SignInRepositoryImpl>((_) => SignInRepositoryImpl(
            signInDatasource: Modular.get<SignInDatasourceImpl>())),
        Bind.singleton<RemoteLoginWithEmailAndPasswordUseCaseImpl>((_) =>
            RemoteLoginWithEmailAndPasswordUseCaseImpl(
                signInRepository: Modular.get<SignInRepositoryImpl>())),
        Bind.singleton<SignInController>((_) => SignInController(
            remoteLoginWithEmailAndPassword:
                Modular.get<RemoteLoginWithEmailAndPasswordUseCaseImpl>())),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (context, args) => SignInPage(),
        ),
      ];
}
