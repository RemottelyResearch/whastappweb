import 'package:whatsappweb/modules/chat/domain/entities/chat_entity.dart';

class ChatModel {
  String idRemetente;
  String idDestinatario;
  String ultimaMensagem;
  String nomeDestinatario;
  String emailDestinatario;
  String urlImagemDestinatario;

  ChatModel({
    required this.idRemetente,
    required this.idDestinatario,
    required this.ultimaMensagem,
    required this.nomeDestinatario,
    required this.emailDestinatario,
    required this.urlImagemDestinatario,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'idRemetente': this.idRemetente,
      'idDestinatario': this.idDestinatario,
      'ultimaMensagem': this.ultimaMensagem,
      'nomeDestinatario': this.nomeDestinatario,
      'emailDestinatario': this.emailDestinatario,
      'urlImagemDestinatario': this.urlImagemDestinatario,
    };

    return map;
  }

  ChatEntity toEntity() {
    return ChatEntity(
      idRemetente: this.idRemetente,
      idDestinatario: this.idDestinatario,
      ultimaMensagem: this.ultimaMensagem,
      nomeDestinatario: this.nomeDestinatario,
      emailDestinatario: this.emailDestinatario,
      urlImagemDestinatario: this.urlImagemDestinatario,
    );
  }

  factory ChatModel.fromEntity(ChatEntity entity) {
    return ChatModel(
      idRemetente: entity.idRemetente,
      idDestinatario: entity.idDestinatario,
      ultimaMensagem: entity.ultimaMensagem,
      nomeDestinatario: entity.nomeDestinatario,
      emailDestinatario: entity.emailDestinatario,
      urlImagemDestinatario: entity.urlImagemDestinatario,
    );
  }
}
