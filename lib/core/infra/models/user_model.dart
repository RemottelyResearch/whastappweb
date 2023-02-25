import 'package:whatsappweb/core/domain/entities/user_entity.dart';

class UserModel {
  String idUsuario;
  String nome;
  String email;
  String urlImagem;

  UserModel({
    required this.idUsuario,
    required this.nome,
    required this.email,
    this.urlImagem = "",
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "idUsuario": this.idUsuario,
      "nome": this.nome,
      "email": this.email,
      "urlImagem": this.urlImagem,
    };

    return map;
  }

  UserEntity toEntity() {
    return UserEntity(
      idUsuario: this.idUsuario,
      nome: this.nome,
      email: this.email,
      urlImagem: this.urlImagem,
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      idUsuario: entity.idUsuario,
      nome: entity.nome,
      email: entity.email,
      urlImagem: entity.urlImagem,
    );
  }
}
