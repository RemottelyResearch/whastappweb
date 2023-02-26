import 'package:whatsappweb/core/domain/entities/user_entity.dart';

abstract class UserRepository {
  UserEntity? remoteGetLoggedUserData();
}
