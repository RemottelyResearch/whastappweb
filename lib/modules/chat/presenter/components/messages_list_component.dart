import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:whatsappweb/core/app_colors.dart';
import 'package:whatsappweb/modules/chat/presenter/controllers/chat_controller.dart';

class MessageListComponent extends StatefulWidget {
  const MessageListComponent({Key? key}) : super(key: key);

  @override
  _MessageListComponentState createState() => _MessageListComponentState();
}

class _MessageListComponentState extends State<MessageListComponent> {
  late ChatController chatController;

  @override
  void initState() {
    super.initState();
    chatController = Modular.get<ChatController>();
    chatController.recuperarMensagens();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    chatController.atualizarListenerMensagens();
  }

  @override
  void dispose() {
    chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;

    return Container(
      width: largura,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('imagens/bg.png'), fit: BoxFit.cover)),
      child: Column(
        children: [
          //Listagem de mensagens
          StreamBuilder(
              stream: chatController.streamController.stream,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Expanded(
                      child: Center(
                        child: Column(
                          children: [
                            Text('Carregando dados'),
                            CircularProgressIndicator()
                          ],
                        ),
                      ),
                    );
                  case ConnectionState.active:
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Center(child: Text('Erro ao carregar os dados!'));
                    } else {
                      QuerySnapshot querySnapshot =
                          snapshot.data as QuerySnapshot;
                      List<DocumentSnapshot> listaMensagens =
                          querySnapshot.docs.toList();

                      return Expanded(
                          child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              reverse: true,
                              controller: chatController.scrollController,
                              itemCount: querySnapshot.docs.length,
                              itemBuilder: (context, indice) {
                                DocumentSnapshot mensagem =
                                    listaMensagens[indice];

                                Alignment alinhamento = Alignment.bottomLeft;
                                Color cor = Colors.white;

                                if (chatController
                                        .usuarioRemetente!.idUsuario ==
                                    mensagem['idUsuario']) {
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
                                    child: Text(mensagem['texto']),
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
                        controller: chatController.controllerMensagem,
                        decoration: InputDecoration(
                            hintText: 'Digite uma mensagem',
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
                      chatController.enviarMensagem();
                    })
              ],
            ),
          )
        ],
      ),
    );
  }
}
