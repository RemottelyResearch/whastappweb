import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:whatsappweb/core/domain/entities/user_entity.dart';
import 'package:whatsappweb/modules/chat/domain/entities/chat_entity.dart';
import 'package:whatsappweb/modules/chat/domain/entities/chat_message_entity.dart';
import 'package:whatsappweb/modules/chat/domain/usecases/remote_save_chat_status_usecase_impl.dart';
import 'package:whatsappweb/modules/chat/infra/models/chat_message_model.dart';

import '../../domain/usecases/remote_load_logged_user_data_usecase.dart';

class ChatController {
  final RemoteLoadLoggedUserDataUseCase remoteLoadLoggedUserData;
  final RemoteSaveChatStatusUseCaseImpl remoteSaveChatStatus;

  ChatController({
    required this.remoteLoadLoggedUserData,
    required this.remoteSaveChatStatus,
  });

  UserEntity? usuarioDestinatario;
  UserEntity? usuarioRemetente;

  loadLoggedUserData() {
    usuarioRemetente = remoteLoadLoggedUserData.call();
  }

  _saveChatStatus(ChatEntity chat) {
    remoteSaveChatStatus.call(chat);
  }

  FirebaseFirestore _firestore = Modular.get<FirebaseFirestore>();

  TextEditingController controllerMensagem = TextEditingController();
  ScrollController scrollController = ScrollController();

  StreamController streamController =
      StreamController<QuerySnapshot>.broadcast();
  late StreamSubscription streamMensagens;

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

  _adicionarListenerMensagens() {
    final stream = _firestore
        .collection('mensagens')
        .doc(usuarioRemetente!.idUsuario)
        .collection(usuarioDestinatario!.idUsuario)
        .orderBy('data', descending: true)
        .snapshots();

    streamMensagens = stream.listen((dados) {
      streamController.add(dados);
    });
  }

  recuperarMensagens() {
    _adicionarListenerMensagens();
  }

  atualizarListenerMensagens() {
    UserEntity? usuarioDestinatario =
        Modular.get<ChatController>().usuarioDestinatario;

    usuarioDestinatario = usuarioDestinatario;
    recuperarMensagens();
  }

  void dispose() {
    scrollController.dispose();
    streamMensagens.cancel();
  }
}
