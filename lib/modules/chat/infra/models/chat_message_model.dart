import 'package:whatsappweb/modules/chat/domain/entities/chat_message_entity.dart';

/// COMENTÁRIO: Mensagens q aparecem dentro do chat
class ChatMessageModel {
  String idUsuario;
  String texto;
  String data;

  ChatMessageModel({
    required this.idUsuario,
    required this.texto,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'idUsuario': this.idUsuario,
      'texto': this.texto,
      'data': this.data,
    };

    return map;
  }

  ChatMessageEntity toEntity() {
    return ChatMessageEntity(
      data: this.data,
      idUsuario: this.idUsuario,
      texto: this.texto,
    );
  }

  factory ChatMessageModel.fromEntity(ChatMessageEntity entity) {
    return ChatMessageModel(
      data: entity.data,
      idUsuario: entity.idUsuario,
      texto: entity.texto,
    );
  }
}
