import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsappweb/core/infra/datasources/user_datasource.dart';
import 'package:whatsappweb/core/infra/models/user_model.dart';

class UserDatasourceImpl implements UserDatasource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  UserDatasourceImpl({
    required this.auth,
    required this.firestore,
  });

  UserModel? remoteFetchLoggedUserData() {
    User? loggedUserData = auth.currentUser;

    if (loggedUserData == null) return null;

    return UserModel(
      idUsuario: loggedUserData.uid,
      nome: loggedUserData.displayName ?? '',
      email: loggedUserData.email ?? '',
      urlImagem: loggedUserData.photoURL ?? '',
    );
  }
}
