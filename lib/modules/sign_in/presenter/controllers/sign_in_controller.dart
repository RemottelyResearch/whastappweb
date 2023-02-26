import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

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

// 1. Page > Flutter Widget
// FEITO
// 2. Controller > Triple
// FEITO
// 3. UseCase
class RemoteLoginWithEmailAndPasswordUseCaseImpl {
  final SignInRepository signInRepository;

  RemoteLoginWithEmailAndPasswordUseCaseImpl({required this.signInRepository});

  Future<UserCredential>? call({
    required String email,
    required String password,
  }) {
    try {
      final userCredentials = signInRepository.loginWithEmailAndPassword(
          email: email, password: password);

      return userCredentials;
    } catch (error) {
      log('[ERROR ON: RemoteLoginWithEmailAndPasswordUseCaseImpl]' +
          error.toString());
    }
    return null;
  }
}

abstract class RemoteLoginWithEmailAndPasswordUseCase {
  Future<UserCredential>? call({
    required String email,
    required String password,
  });
}

// 4. Repository
class SignInRepositoryImpl implements SignInRepository {
  final SignInDatasource signInDatasource;

  SignInRepositoryImpl({required this.signInDatasource});

  Future<UserCredential> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return signInDatasource.signInWithEmailAndPassword(
        email: email, password: password);
  }
}

abstract class SignInRepository {
  Future<UserCredential> loginWithEmailAndPassword({
    required String email,
    required String password,
  });
}

// 5. Datasource
class SignInDatasourceImpl implements SignInDatasource {
  final FirebaseAuth auth;

  SignInDatasourceImpl({required this.auth});

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await auth.signInWithEmailAndPassword(
        email: email, password: password);
  }
}

abstract class SignInDatasource {
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
}
