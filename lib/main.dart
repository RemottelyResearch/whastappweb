import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsappweb/provider/conversa_provider.dart';
import 'package:whatsappweb/rotas.dart';
import 'package:whatsappweb/uteis/paleta_cores.dart';

final ThemeData temaPadrao = ThemeData(
    primaryColor: PaletaCores.corPrimaria,
    colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: PaletaCores.corDestaque));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  User? usuarioFirebase = FirebaseAuth.instance.currentUser;
  String urlInicial = "/";
  if (usuarioFirebase != null) {
    urlInicial = "/home";
  }

  runApp(ChangeNotifierProvider(
    create: (context) => ConversaProvider(),
    child: MaterialApp(
      title: "WhatsApp Web",
      debugShowCheckedModeBanner: false,
      // home: Login(),
      theme: temaPadrao,
      initialRoute: urlInicial,
      onGenerateRoute: Rotas.gerarRota,
    ),
  ));
}
