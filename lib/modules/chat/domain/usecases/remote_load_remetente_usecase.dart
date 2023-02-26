import 'package:whatsappweb/core/domain/entities/user_entity.dart';

abstract class RemoteLoadLoggedUserDataUseCase {
  UserEntity? call();
}
