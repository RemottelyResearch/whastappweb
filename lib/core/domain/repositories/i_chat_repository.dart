import 'package:whatsappweb/core/domain/entities/user_entity.dart';

abstract class IChatRepository {
  UserEntity? get usuarioDestinatario;

  set usuarioDestinatario(UserEntity? usuario);
}
