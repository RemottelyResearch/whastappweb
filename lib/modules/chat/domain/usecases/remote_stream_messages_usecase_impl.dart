import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsappweb/modules/chat/domain/repositories/chat_repository.dart';
import 'package:whatsappweb/modules/chat/domain/usecases/remote_stream_messages_usecase.dart';

class RemoteStreamMessagesUseCaseImpl implements RemoteStreamMessagesUseCase {
  final ChatRepository chatRepository;

  RemoteStreamMessagesUseCaseImpl(this.chatRepository);

  Stream<QuerySnapshot<Map<String, dynamic>>> call({
    required String idLoggedUser,
    required String idRecipientUser,
  }) {
    return chatRepository.remoteStreamMessages(
      idLoggedUser: idLoggedUser,
      idRecipientUser: idRecipientUser,
    );
  }
}
