import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:whatsappweb/core/domain/entities/user_entity.dart';

class ChatsListTab extends StatefulWidget {
  const ChatsListTab({Key? key}) : super(key: key);

  @override
  _ChatsListTabState createState() => _ChatsListTabState();
}

class _ChatsListTabState extends State<ChatsListTab> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  late UserEntity _usuarioRemetente;
  StreamController _streamController =
      StreamController<QuerySnapshot>.broadcast();
  late StreamSubscription _streamConversas;

  _recuperarDadosIniciais() {
    User? usuarioLogado = _auth.currentUser;
    if (usuarioLogado != null) {
      String idUsuario = usuarioLogado.uid;
      String? nome = usuarioLogado.displayName ?? "";
      String? email = usuarioLogado.email ?? "";
      String? urlImagem = usuarioLogado.photoURL ?? "";

      _usuarioRemetente = UserEntity(
        idUsuario: idUsuario,
        nome: nome,
        email: email,
        urlImagem: urlImagem,
      );
    }

    _adicionarListenerConversas();
  }

  _adicionarListenerConversas() {
    final stream = _firestore
        .collection("conversas")
        .doc(_usuarioRemetente.idUsuario)
        .collection("ultimas_mensagens")
        .snapshots();

    _streamConversas = stream.listen((dados) {
      _streamController.add(dados);
    });
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosIniciais();
  }

  @override
  void dispose() {
    _streamConversas.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _streamController.stream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  children: [
                    Text("Carregando conversas"),
                    CircularProgressIndicator()
                  ],
                ),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(child: Text("Erro ao carregar os dados!"));
              } else {
                QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;
                List<DocumentSnapshot> listaConversas =
                    querySnapshot.docs.toList();

                return ListView.separated(
                  separatorBuilder: (context, indice) {
                    return Divider(
                      color: Colors.grey,
                      thickness: 0.2,
                    );
                  },
                  itemCount: listaConversas.length,
                  itemBuilder: (context, indice) {
                    DocumentSnapshot conversa = listaConversas[indice];
                    String urlImagemDestinatario =
                        conversa["urlImagemDestinatario"];
                    String nomeDestinatario = conversa["nomeDestinatario"];
                    String emailDestinatario = conversa["emailDestinatario"];
                    String ultimaMensagem = conversa["ultimaMensagem"];
                    String idDestinatario = conversa["idDestinatario"];

                    UserEntity usuario = UserEntity(
                      idUsuario: idDestinatario,
                      nome: nomeDestinatario,
                      email: emailDestinatario,
                      urlImagem: urlImagemDestinatario,
                    );

                    return ListTile(
                      onTap: () {
                        Modular.to.pushNamed("/mensagens", arguments: usuario);
                      },
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            CachedNetworkImageProvider(usuario.urlImagem),
                      ),
                      title: Text(
                        usuario.nome,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        ultimaMensagem,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      contentPadding: EdgeInsets.all(8),
                    );
                  },
                );
              }
          }
        });
  }
}
