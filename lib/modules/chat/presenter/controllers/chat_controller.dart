import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:whatsappweb/core/domain/entities/user_entity.dart';
import 'package:whatsappweb/core/domain/usecases/remote_load_logged_user_data_usecase.dart';
import 'package:whatsappweb/modules/chat/domain/entities/chat_entity.dart';
import 'package:whatsappweb/modules/chat/domain/entities/chat_message_entity.dart';
import 'package:whatsappweb/modules/chat/domain/helpers/end_connection_status_type.dart';
import 'package:whatsappweb/modules/chat/domain/repositories/chat_repository.dart';
import 'package:whatsappweb/modules/chat/domain/usecases/remote_save_chat_status_usecase.dart';
import 'package:whatsappweb/modules/chat/domain/usecases/remote_stream_messages_usecase.dart';
import 'package:whatsappweb/modules/chat/infra/models/chat_message_model.dart';

class ChatController {
  final RemoteLoadLoggedUserDataUseCase remoteLoadLoggedUserData;
  final RemoteSaveChatStatusUseCase remoteSaveChatStatus;
  final RemoteStreamMessagesUseCase remoteStreamMessages;
  final RemoteSaveMessageUseCase remoteSaveMessage;

  ChatController({
    required this.remoteLoadLoggedUserData,
    required this.remoteSaveChatStatus,
    required this.remoteStreamMessages,
    required this.remoteSaveMessage,
  });

  UserEntity? usuarioDestinatario;
  UserEntity? usuarioRemetente;

  TextEditingController controllerMensagem = TextEditingController();
  ScrollController scrollController = ScrollController();

  StreamController streamController =
      StreamController<QuerySnapshot>.broadcast();
  late StreamSubscription streamMensagens;

  void dispose() {
    scrollController.dispose();
    streamMensagens.cancel();
  }

  /// >>> Finalizados

  void loadLoggedUserData() {
    usuarioRemetente = remoteLoadLoggedUserData.call();
  }

  void adicionarListenerMensagens() {
    final stream = remoteStreamMessages.call(
      idLoggedUser: usuarioRemetente!.idUsuario,
      idRecipientUser: usuarioDestinatario!.idUsuario,
    );

    if (stream == null) {
      // TODO: show some error
      return;
    }
    streamMensagens = stream.listen((dados) {
      streamController.add(dados);
    });
  }

  void atualizarListenerMensagens() {
    UserEntity? usuarioDestinatario =
        Modular.get<ChatController>().usuarioDestinatario;

    usuarioDestinatario = usuarioDestinatario;
    adicionarListenerMensagens();
  }

  Future<void> _saveChatStatus(ChatEntity chat) async {
    await remoteSaveChatStatus.call(chat);
  }

  Future<void> _saveMessage({
    required String idLoggedUser,
    required String idRecipient,
    required ChatMessageEntity message,
  }) async {
    // chamar caso de uso
    await remoteSaveMessage.call(
      idLoggedUser: idLoggedUser,
      idRecipient: idRecipient,
      message: message,
    );
    controllerMensagem.clear();
  }

  Future<void> enviarMensagem() async {
    String textoMensagem = controllerMensagem.text;
    if (textoMensagem.isNotEmpty) {
      String idUsuarioRemetente = usuarioRemetente!.idUsuario;
      ChatMessageEntity mensagem = ChatMessageEntity(
        idUsuario: idUsuarioRemetente,
        texto: textoMensagem,
        data: Timestamp.now().toString(),
      );

      //Salvar mensagem para remetente
      String idUsuarioDestinatario = usuarioDestinatario!.idUsuario;
      await _saveMessage(
        idLoggedUser: idUsuarioRemetente,
        idRecipient: idUsuarioDestinatario,
        message: mensagem,
      );
      ChatEntity conversaRementente = ChatEntity(
        emailDestinatario: usuarioDestinatario!.email,
        idDestinatario: idUsuarioDestinatario,
        idRemetente: idUsuarioRemetente,
        nomeDestinatario: usuarioDestinatario!.nome,
        ultimaMensagem: mensagem.texto,
        urlImagemDestinatario: usuarioDestinatario!.urlImagem,
      );
      await _saveChatStatus(conversaRementente);

      //Salvar mensagem para destinatário
      await _saveMessage(
        idLoggedUser: idUsuarioDestinatario,
        idRecipient: idUsuarioRemetente,
        message: mensagem,
      );
      ChatEntity conversaDestinatario = ChatEntity(
        emailDestinatario: usuarioRemetente!.email,
        idDestinatario: idUsuarioRemetente,
        idRemetente: idUsuarioDestinatario,
        nomeDestinatario: usuarioRemetente!.nome,
        ultimaMensagem: mensagem.texto,
        urlImagemDestinatario: usuarioRemetente!.urlImagem,
      );
      await _saveChatStatus(conversaDestinatario);
    }
  }

  /// <<< Finalizados
}

class RemoteSaveMessageUseCaseImpl implements RemoteSaveMessageUseCase {
  final ChatRepository chatRepository;

  RemoteSaveMessageUseCaseImpl({required this.chatRepository});

  @override
  Future<EndConnectionStatusType> call(
      {required String idLoggedUser,
      required String idRecipient,
      required ChatMessageEntity message}) async {
    try {
      await chatRepository.putMessage(
        idLoggedUser: idLoggedUser,
        idRecipient: idRecipient,
        message: ChatMessageModel.fromEntity(message),
      );
      return EndConnectionStatusType.successed;
    } catch (error) {
      log('[ERROR ON: RemoteSaveMessageUseCaseImpl]' + error.toString());
      return EndConnectionStatusType.failed;
    }
  }
}

abstract class RemoteSaveMessageUseCase {
  Future<EndConnectionStatusType> call({
    required String idLoggedUser,
    required String idRecipient,
    required ChatMessageEntity message,
  });
}
