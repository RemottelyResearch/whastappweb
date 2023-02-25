class ChatEntity {
  String idRemetente;
  String idDestinatario;
  String ultimaMensagem;
  String nomeDestinatario;
  String emailDestinatario;
  String urlImagemDestinatario;

  ChatEntity({
    required this.idRemetente,
    required this.idDestinatario,
    required this.ultimaMensagem,
    required this.nomeDestinatario,
    required this.emailDestinatario,
    required this.urlImagemDestinatario,
  });
}
