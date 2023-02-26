import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:whatsappweb/core/domain/entities/user_entity.dart';
import 'package:whatsappweb/modules/chat/domain/entities/chat_entity.dart';
import 'package:whatsappweb/modules/chat/domain/entities/chat_message_entity.dart';
import 'package:whatsappweb/modules/chat/infra/models/chat_message_model.dart';
import 'package:whatsappweb/modules/chat/infra/models/chat_model.dart';

import '../../domain/usecases/remote_load_remetente_usecase.dart';

class ChatController {
  final RemoteLoadLoggedUserDataUseCase remoteLoadLoggedUserData;

  ChatController({
    required this.remoteLoadLoggedUserData,
  });

  UserEntity? usuarioDestinatario;
  UserEntity? usuarioRemetente;

  loadLoggedUserData() {
    usuarioRemetente = remoteLoadLoggedUserData.call();
  }

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      _salvarConversa(conversaRementente);

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
      _salvarConversa(conversaDestinatario);
    }
  }

  _salvarConversa(ChatEntity conversa) {
    final chatEntityMap = ChatModel.fromEntity(conversa).toMap();
    _firestore
        .collection('conversas')
        .doc(conversa.idRemetente)
        .collection('ultimas_mensagens')
        .doc(conversa.idDestinatario)
        .set(chatEntityMap);
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
