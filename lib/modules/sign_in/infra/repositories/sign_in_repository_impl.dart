import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsappweb/modules/sign_in/domain/repositories/sign_in_repository.dart';
import 'package:whatsappweb/modules/sign_in/infra/datasources/sign_in_datasource.dart';

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
