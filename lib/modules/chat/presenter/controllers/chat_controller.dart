import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:whatsappweb/core/domain/entities/user_entity.dart';
import 'package:whatsappweb/core/domain/usecases/remote_load_logged_user_data_usecase.dart';
import 'package:whatsappweb/modules/chat/domain/entities/chat_entity.dart';
import 'package:whatsappweb/modules/chat/domain/entities/chat_message_entity.dart';
import 'package:whatsappweb/modules/chat/domain/usecases/remote_save_chat_status_usecase.dart';
import 'package:whatsappweb/modules/chat/domain/usecases/remote_stream_messages_usecase.dart';
import 'package:whatsappweb/modules/chat/infra/models/chat_message_model.dart';

class ChatController {
  final RemoteLoadLoggedUserDataUseCase remoteLoadLoggedUserData;
  final RemoteSaveChatStatusUseCase remoteSaveChatStatus;
  final RemoteStreamMessagesUseCase remoteStreamMessages;

  ChatController({
    required this.remoteLoadLoggedUserData,
    required this.remoteSaveChatStatus,
    required this.remoteStreamMessages,
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

  loadLoggedUserData() {
    usuarioRemetente = remoteLoadLoggedUserData.call();
  }

  adicionarListenerMensagens() {
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

  atualizarListenerMensagens() {
    UserEntity? usuarioDestinatario =
        Modular.get<ChatController>().usuarioDestinatario;

    usuarioDestinatario = usuarioDestinatario;
    adicionarListenerMensagens();
  }

  _saveChatStatus(ChatEntity chat) {
    remoteSaveChatStatus.call(chat);
  }

  /// <<< Finalizados

  FirebaseFirestore _firestore = Modular.get<FirebaseFirestore>();

  enviarMensagem() {
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
      _salvarMensagem(idUsuarioRemetente, idUsuarioDestinatario, mensagem);
      ChatEntity conversaRementente = ChatEntity(
        emailDestinatario: usuarioDestinatario!.email,
        idDestinatario: idUsuarioDestinatario,
        idRemetente: idUsuarioRemetente,
        nomeDestinatario: usuarioDestinatario!.nome,
        ultimaMensagem: mensagem.texto,
        urlImagemDestinatario: usuarioDestinatario!.urlImagem,
      );
      _saveChatStatus(conversaRementente);

      //Salvar mensagem para destinatário
      _salvarMensagem(idUsuarioDestinatario, idUsuarioRemetente, mensagem);
      ChatEntity conversaDestinatario = ChatEntity(
        emailDestinatario: usuarioRemetente!.email,
        idDestinatario: idUsuarioRemetente,
        idRemetente: idUsuarioDestinatario,
        nomeDestinatario: usuarioRemetente!.nome,
        ultimaMensagem: mensagem.texto,
        urlImagemDestinatario: usuarioRemetente!.urlImagem,
      );
      _saveChatStatus(conversaDestinatario);
    }
  }

  _salvarMensagem(
      String idRemetente, String idDestinatario, ChatMessageEntity mensagem) {
    final chatMessageMap = ChatMessageModel.fromEntity(mensagem).toMap();
    _firestore
        .collection('mensagens')
        .doc(idRemetente)
        .collection(idDestinatario)
        .add(chatMessageMap);

    controllerMensagem.clear();
  }
}
