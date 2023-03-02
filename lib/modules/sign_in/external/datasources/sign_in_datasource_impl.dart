import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsappweb/modules/sign_in/infra/datasources/sign_in_datasource.dart';

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
