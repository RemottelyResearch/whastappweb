import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:whatsappweb/core/infra/mappers/user_model.dart';

class ContactsListTab extends StatefulWidget {
  const ContactsListTab({Key? key}) : super(key: key);

  @override
  _ContactsListTabState createState() => _ContactsListTabState();
}

class _ContactsListTabState extends State<ContactsListTab> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String _idUsuarioLogado;

  Future<List<UserModel>> _recuperarContatos() async {
    final usuarioRef = _firestore.collection("usuarios");
    QuerySnapshot querySnapshot = await usuarioRef.get();
    List<UserModel> listaUsuarios = [];

    for (DocumentSnapshot item in querySnapshot.docs) {
      String idUsuario = item["idUsuario"];
      if (idUsuario == _idUsuarioLogado) continue;

      String email = item["email"];
      String nome = item["nome"];
      String urlImagem = item["urlImagem"];

      UserModel usuario =
          UserModel(idUsuario, nome, email, urlImagem: urlImagem);
      listaUsuarios.add(usuario);
    }

    return listaUsuarios;
  }

  _recuperarDadosUsuarioLogado() async {
    User? usuarioAtual = _auth.currentUser;
    if (usuarioAtual != null) {
      _idUsuarioLogado = usuarioAtual.uid;
    }
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuarioLogado();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserModel>>(
        future: _recuperarContatos(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  children: [
                    Text("Carregando contatos"),
                    CircularProgressIndicator()
                  ],
                ),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(child: Text("Erro ao carregar os dados!"));
              } else {
                List<UserModel>? listaUsuarios = snapshot.data;
                if (listaUsuarios != null) {
                  return ListView.separated(
                    separatorBuilder: (context, indice) {
                      return Divider(
                        color: Colors.grey,
                        thickness: 0.2,
                      );
                    },
                    itemCount: listaUsuarios.length,
                    itemBuilder: (context, indice) {
                      UserModel usuario = listaUsuarios[indice];
                      return ListTile(
                        onTap: () {
                          Modular.to
                              .pushNamed("/mensagens", arguments: usuario);
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
                        contentPadding: EdgeInsets.all(8),
                      );
                    },
                  );
                }

                return Center(child: Text("Nenhum contato encontrado!"));
              }
          }
        });
  }
}