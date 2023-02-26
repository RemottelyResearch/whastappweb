import 'package:whatsappweb/core/infra/models/user_model.dart';

abstract class ChatDatasource {
  UserModel? remoteFetchRemetente();
}
