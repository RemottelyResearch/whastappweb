import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:whatsappweb/core/app_colors.dart';

class AppWidget extends StatelessWidget with WidgetsBindingObserver {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        title: 'WhatsApp Web',
        debugShowCheckedModeBanner: false,
        theme: temaPadrao,
        routeInformationParser: Modular.routeInformationParser,
        routerDelegate: Modular.routerDelegate,
        builder: (context, child) {
          // TODO: USECASE
          User? usuarioFirebase = Modular.get<FirebaseAuth>().currentUser;
          late String urlInicial;

          if (usuarioFirebase != null) {
            urlInicial = '/';
          } else {
            urlInicial = '/login';
          }

          Modular.to.navigate(urlInicial);

          return child ?? Container();
        });
  }
}
