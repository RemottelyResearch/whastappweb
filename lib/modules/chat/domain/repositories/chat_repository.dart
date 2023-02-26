import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsappweb/core/domain/entities/user_entity.dart';

abstract class ChatRepository {
  UserEntity? remoteGetLoggedUserData();
  Stream<QuerySnapshot<Map<String, dynamic>>> remoteStreamMessages({
    required String idLoggedUser,
    required String idRecipientUser,
  });
}
