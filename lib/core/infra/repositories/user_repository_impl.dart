import 'package:whatsappweb/core/domain/entities/repositories/user_repository.dart';
import 'package:whatsappweb/core/domain/entities/user_entity.dart';
import 'package:whatsappweb/core/external/datasources/user_datasource_impl.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDatasourceImpl userDatasource;

  const UserRepositoryImpl(this.userDatasource);

  UserEntity? remoteGetLoggedUserData() {
    return userDatasource.remoteFetchLoggedUserData()?.toEntity();
  }
}
