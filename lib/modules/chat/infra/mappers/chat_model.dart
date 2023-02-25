class ChatModel {
  String idRemetente;
  String idDestinatario;
  String ultimaMensagem;
  String nomeDestinatario;
  String emailDestinatario;
  String urlImagemDestinatario;

  ChatModel(
    this.idRemetente,
    this.idDestinatario,
    this.ultimaMensagem,
    this.nomeDestinatario,
    this.emailDestinatario,
    this.urlImagemDestinatario,
  );

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "idRemetente": this.idRemetente,
      "idDestinatario": this.idDestinatario,
      "ultimaMensagem": this.ultimaMensagem,
      "nomeDestinatario": this.nomeDestinatario,
      "emailDestinatario": this.emailDestinatario,
      "urlImagemDestinatario": this.urlImagemDestinatario,
    };

    return map;
  }
}
