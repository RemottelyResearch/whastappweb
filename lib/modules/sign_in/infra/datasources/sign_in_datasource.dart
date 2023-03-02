import 'package:firebase_auth/firebase_auth.dart';

abstract class SignInDatasource {
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
}
