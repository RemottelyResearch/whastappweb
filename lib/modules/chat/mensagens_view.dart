import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappweb/core/usuario.dart';
import 'package:whatsappweb/modules/chat/lista_mensagens.dart';

class MensagensView extends StatefulWidget {
  final Usuario usuarioDestinatario;

  const MensagensView(this.usuarioDestinatario, {Key? key}) : super(key: key);

  @override
  _MensagensViewState createState() => _MensagensViewState();
}

class _MensagensViewState extends State<MensagensView> {
  late Usuario _usuarioRemetente;
  late Usuario _usuarioDestinatario;
  FirebaseAuth _auth = FirebaseAuth.instance;

  _recuperarDadosIniciais() {
    _usuarioDestinatario = widget.usuarioDestinatario;

    User? usuarioLogado = _auth.currentUser;
    if (usuarioLogado != null) {
      String idUsuario = usuarioLogado.uid;
      String? nome = usuarioLogado.displayName ?? "";
      String? email = usuarioLogado.email ?? "";
      String? urlImagem = usuarioLogado.photoURL ?? "";

      _usuarioRemetente = Usuario(
        idUsuario,
        nome,
        email,
        urlImagem: urlImagem,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosIniciais();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey,
              backgroundImage:
                  CachedNetworkImageProvider(_usuarioDestinatario.urlImagem),
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              _usuarioDestinatario.nome,
              style: TextStyle(color: Colors.white, fontSize: 16),
            )
          ],
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))],
      ),
      body: SafeArea(
        child: ListaMensagens(
          usuarioRemetente: _usuarioRemetente,
          usuarioDestinatario: _usuarioDestinatario,
        ),
      ),
    );
  }
}
