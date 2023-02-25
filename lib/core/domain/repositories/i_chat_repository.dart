import 'package:whatsappweb/core/infra/models/user_model.dart';

abstract class IChatRepository {
  UserModel? get usuarioDestinatario;

  set usuarioDestinatario(UserModel? usuario);
}
