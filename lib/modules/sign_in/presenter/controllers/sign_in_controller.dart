import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:whatsappweb/modules/sign_in/domain/usecases/remote_login_with_email_and_password_usecase_impl.dart';

class SignInController {
  final RemoteLoginWithEmailAndPasswordUseCaseImpl
      remoteLoginWithEmailAndPassword;

  SignInController({required this.remoteLoginWithEmailAndPassword});

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
        final userCredentials = await remoteLoginWithEmailAndPassword.call(
            email: email, password: senha);

        if (userCredentials == null) {
          // TODO: SHOW ERROR
          return;
        }

        Modular.to.navigate('/');
      } else {
        print('Senha inválida');
      }
    } else {
      print('Email inválido');
    }
  }
}
