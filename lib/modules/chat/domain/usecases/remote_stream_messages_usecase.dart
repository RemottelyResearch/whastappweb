import 'package:cloud_firestore/cloud_firestore.dart';

abstract class RemoteStreamMessagesUseCase {
  Stream<QuerySnapshot<Map<String, dynamic>>> call(
      {required String idLoggedUser, required String idRecipientUser});
}
