import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_chat_app/feature/login/data/models/login_model.dart';
import 'package:ohio_chat_app/feature/login/domain/repositories/login_repositories.dart';

final loginRepositoryProvider = Provider.autoDispose<LoginRepositoriesImpl>(
    (ref) => LoginRepositoriesImpl());

class LoginRepositoriesImpl implements LoginRepositories {
  @override
  Future<LoginModel> fetchUsername() async {
    return const LoginModel(userName: 'Tuấn Anh');
  }
}
