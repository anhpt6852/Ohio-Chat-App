import 'package:ohio_chat_app/feature/login/data/models/login_model.dart';

abstract class LoginRepositories {
  Future<LoginModel> fetchUsername();
}
