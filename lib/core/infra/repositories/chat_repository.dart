import 'package:flutter/material.dart';
import 'package:whatsappweb/core/domain/repositories/i_chat_repository.dart';
import 'package:whatsappweb/core/infra/models/user_model.dart';

class ChatRepository extends ChangeNotifier implements IChatRepository {
  UserModel? _usuarioDestinatario;

  UserModel? get usuarioDestinatario => _usuarioDestinatario;

  set usuarioDestinatario(UserModel? usuario) {
    _usuarioDestinatario = usuario;
    notifyListeners();
  }
}
