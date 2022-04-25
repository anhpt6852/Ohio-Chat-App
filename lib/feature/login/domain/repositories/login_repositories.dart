import 'package:ohio_templates/feature/login/data/models/login_model.dart';

abstract class LoginRepositories {
  Future<LoginModel> fetchUsername();
}