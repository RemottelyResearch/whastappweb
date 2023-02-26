import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:whatsappweb/core/app_colors.dart';
import 'package:whatsappweb/core/domain/entities/user_entity.dart';
import 'package:whatsappweb/core/infra/repositories/chat_repository.dart';
import 'package:whatsappweb/modules/chat/domain/entities/chat_entity.dart';
import 'package:whatsappweb/modules/chat/domain/entities/chat_message_entity.dart';
import 'package:whatsappweb/modules/chat/infra/models/chat_message_model.dart';
import 'package:whatsappweb/modules/chat/infra/models/chat_model.dart';

class MessageListComponent extends StatefulWidget {
  final UserEntity usuarioRemetente;
  final UserEntity usuarioDestinatario;

  const MessageListComponent({
    Key? key,
    required this.usuarioRemetente,
    required this.usuarioDestinatario,
  }) : super(key: key);

  @override
  _MessageListComponentState createState() => _MessageListComponentState();
}

class _MessageListComponentState extends State<MessageListComponent> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController _controllerMensagem = TextEditingController();
  ScrollController _scrollController = ScrollController();
  late UserEntity _usuarioRemetente;
  late UserEntity _usuarioDestinatario;

  StreamController _streamController =
      StreamController<QuerySnapshot>.broadcast();
  late StreamSubscription _streamMensagens;

  _enviarMensagem() {
    String textoMensagem = _controllerMensagem.text;
    if (textoMensagem.isNotEmpty) {
      String idUsuarioRemetente = _usuarioRemetente.idUsuario;
      ChatMessageEntity mensagem = ChatMessageEntity(
        idUsuario: idUsuarioRemetente,
        texto: textoMensagem,
        data: Timestamp.now().toString(),
      );

      //Salvar mensagem para remetente
      String idUsuarioDestinatario = _usuarioDestinatario.idUsuario;
      _salvarMensagem(idUsuarioRemetente, idUsuarioDestinatario, mensagem);
      ChatEntity conversaRementente = ChatEntity(
        emailDestinatario: _usuarioDestinatario.email,
        idDestinatario: idUsuarioDestinatario,
        idRemetente: idUsuarioRemetente,
        nomeDestinatario: _usuarioDestinatario.nome,
        ultimaMensagem: mensagem.texto,
        urlImagemDestinatario: _usuarioDestinatario.urlImagem,
      );
      _salvarConversa(conversaRementente);

      //Salvar mensagem para destinatário
      _salvarMensagem(idUsuarioDestinatario, idUsuarioRemetente, mensagem);
      ChatEntity conversaDestinatario = ChatEntity(
        emailDestinatario: _usuarioRemetente.email,
        idDestinatario: idUsuarioRemetente,
        idRemetente: idUsuarioDestinatario,
        nomeDestinatario: _usuarioRemetente.nome,
        ultimaMensagem: mensagem.texto,
        urlImagemDestinatario: _usuarioRemetente.urlImagem,
      );
      _salvarConversa(conversaDestinatario);
    }
  }

  _salvarConversa(ChatEntity conversa) {
    final chatEntityMap = ChatModel.fromEntity(conversa).toMap();
    _firestore
        .collection("conversas")
        .doc(conversa.idRemetente)
        .collection("ultimas_mensagens")
        .doc(conversa.idDestinatario)
        .set(chatEntityMap);
  }

  _salvarMensagem(
      String idRemetente, String idDestinatario, ChatMessageEntity mensagem) {
    final chatMessageMap = ChatMessageModel.fromEntity(mensagem).toMap();
    _firestore
        .collection("mensagens")
        .doc(idRemetente)
        .collection(idDestinatario)
        .add(chatMessageMap);

    _controllerMensagem.clear();
  }

  _adicionarListenerMensagens() {
    final stream = _firestore
        .collection("mensagens")
        .doc(_usuarioRemetente.idUsuario)
        .collection(_usuarioDestinatario.idUsuario)
        .orderBy("data", descending: true)
        .snapshots();

    _streamMensagens = stream.listen((dados) {
      _streamController.add(dados);
      // Timer(Duration(milliseconds: 300), () {
      //   _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      // });
    });
  }

  _recuperarDadosInicias() {
    _usuarioRemetente = widget.usuarioRemetente;
    _usuarioDestinatario = widget.usuarioDestinatario;

    _adicionarListenerMensagens();
  }

  _atualizarListenerMensagens() {
    UserEntity? usuarioDestinatario =
        Modular.get<ChatRepository>().usuarioDestinatario;

    if (usuarioDestinatario != null) {
      _usuarioDestinatario = usuarioDestinatario;
      _recuperarDadosInicias();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _streamMensagens.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosInicias();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _atualizarListenerMensagens();
  }

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;

    return Container(
      width: largura,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("imagens/bg.png"), fit: BoxFit.cover)),
      child: Column(
        children: [
          //Listagem de mensagens
          StreamBuilder(
              stream: _streamController.stream,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Expanded(
                      child: Center(
                        child: Column(
                          children: [
                            Text("Carregando dados"),
                            CircularProgressIndicator()
                          ],
                        ),
                      ),
                    );
                  case ConnectionState.active:
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Center(child: Text("Erro ao carregar os dados!"));
                    } else {
                      QuerySnapshot querySnapshot =
                          snapshot.data as QuerySnapshot;
                      List<DocumentSnapshot> listaMensagens =
                          querySnapshot.docs.toList();

                      return Expanded(
                          child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              reverse: true,
                              controller: _scrollController,
                              itemCount: querySnapshot.docs.length,
                              itemBuilder: (context, indice) {
                                DocumentSnapshot mensagem =
                                    listaMensagens[indice];

                                Alignment alinhamento = Alignment.bottomLeft;
                                Color cor = Colors.white;

                                if (_usuarioRemetente.idUsuario ==
                                    mensagem["idUsuario"]) {
                                  alinhamento = Alignment.bottomRight;
                                  cor = Color(0xffd2ffa5);
                                }

                                Size largura =
                                    MediaQuery.of(context).size * 0.8;

                                return Align(
                                  alignment: alinhamento,
                                  child: Container(
                                    constraints: BoxConstraints.loose(largura),
                                    decoration: BoxDecoration(
                                        color: cor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    padding: EdgeInsets.all(16),
                                    margin: EdgeInsets.all(6),
                                    child: Text(mensagem["texto"]),
                                  ),
                                );
                              }));
                    }
                }
              }),

          //Caixa de texto
          Container(
            padding: EdgeInsets.all(8),
            color: AppColors.corFundoBarra,
            child: Row(
              children: [
                //Caixa de texto arredondada
                Expanded(
                    child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40)),
                  child: Row(
                    children: [
                      Icon(Icons.insert_emoticon),
                      SizedBox(
                        width: 4,
                      ),
                      Expanded(
                          child: TextField(
                        controller: _controllerMensagem,
                        decoration: InputDecoration(
                            hintText: "Digite uma mensagem",
                            border: InputBorder.none),
                      )),
                      Icon(Icons.attach_file),
                      Icon(Icons.camera_alt),
                    ],
                  ),
                )),

                //Botao Enviar
                FloatingActionButton(
                    backgroundColor: AppColors.corPrimaria,
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    mini: true,
                    onPressed: () {
                      _enviarMensagem();
                    })
              ],
            ),
          )
        ],
      ),
    );
  }
}
