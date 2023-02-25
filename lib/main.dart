import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:whatsappweb/core/paleta_cores.dart';
import 'package:whatsappweb/modules/app_module.dart';

import 'modules/app_widget.dart';

final ThemeData temaPadrao = ThemeData(
    // TODO: COLOCAR EM OUTRO ARQUIVO
    primaryColor: PaletaCores.corPrimaria,
    colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: PaletaCores.corDestaque));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(ModularApp(
    module: AppModule(),
    child: AppWidget(),
  ));
}
