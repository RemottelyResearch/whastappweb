class UserEntity {
  String idUsuario;
  String nome;
  String email;
  String urlImagem;

  UserEntity({
    required this.idUsuario,
    required this.nome,
    required this.email,
    this.urlImagem = "",
  });
}
