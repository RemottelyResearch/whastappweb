import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:whatsappweb/core/domain/entities/user_entity.dart';
import 'package:whatsappweb/modules/chat/presenter/components/messages_list_component.dart';
import 'package:whatsappweb/modules/chat/presenter/controllers/chat_controller.dart';

class ChatPage extends StatefulWidget {
  final UserEntity usuarioDestinatario;

  const ChatPage(this.usuarioDestinatario, {Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatController chatController;

  @override
  void initState() {
    super.initState();
    chatController = Modular.get<ChatController>();
    chatController.usuarioDestinatario = widget.usuarioDestinatario;
    chatController.recuperarDadosIniciais();
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
              backgroundImage: CachedNetworkImageProvider(
                  chatController.usuarioDestinatario!.urlImagem),
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              chatController.usuarioDestinatario!.nome,
              style: TextStyle(color: Colors.white, fontSize: 16),
            )
          ],
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))],
      ),
      body: SafeArea(
        child: MessageListComponent(
          usuarioRemetente: chatController.usuarioRemetente!,
          usuarioDestinatario: chatController.usuarioDestinatario!,
        ),
      ),
    );
  }
}
