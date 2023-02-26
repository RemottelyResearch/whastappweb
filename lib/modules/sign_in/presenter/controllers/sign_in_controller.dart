import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SignInController {
  TextEditingController controllerEmail =
      TextEditingController(text: 'jamilton@gmail.com');
  TextEditingController controllerSenha =
      TextEditingController(text: '1234567');
  FirebaseAuth auth = Modular.get<FirebaseAuth>();

  // verificarUsuarioLogado(){
  //
  //   User? usuarioLogado = auth.currentUser;
  //
  //   if( usuarioLogado != null ){
  //     Modular.to.navigate('/');
  //   }
  //
  // }

  validarCampos() async {
    String email = controllerEmail.text;
    String senha = controllerSenha.text;

    if (email.isNotEmpty && email.contains('@')) {
      if (senha.isNotEmpty && senha.length > 6) {
        //Login
        await auth
            .signInWithEmailAndPassword(email: email, password: senha)
            .then((auth) {
          //tela principal
          Modular.to.navigate('/');
        });
      } else {
        print('Senha inválida');
      }
    } else {
      print('Email inválido');
    }
  }
}
