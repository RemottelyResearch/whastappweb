import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsappweb/modules/sign_in/domain/repositories/sign_in_repository.dart';

class RemoteLoginWithEmailAndPasswordUseCaseImpl {
  final SignInRepository signInRepository;

  RemoteLoginWithEmailAndPasswordUseCaseImpl({required this.signInRepository});

  Future<UserCredential?> call({
    required String email,
    required String password,
  }) async {
    try {
      final userCredentials = await signInRepository.loginWithEmailAndPassword(
          email: email, password: password);

      return userCredentials;
    } catch (error) {
      log('[ERROR ON: RemoteLoginWithEmailAndPasswordUseCaseImpl]' +
          error.toString());
    }
    return Future.value(null);
  }
}
