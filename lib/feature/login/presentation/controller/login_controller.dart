import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_templates/feature/login/data/models/login_model.dart';
import 'package:ohio_templates/feature/login/data/repositories/login_repositories_impl.dart';
import 'package:ohio_templates/feature/login/domain/repositories/login_repositories.dart';
import 'package:ohio_templates/routes.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

final loginControllerProvider = Provider.autoDispose((ref) {
  final loginRepositories = ref.watch(loginRepositoryProvider);
  return LoginController(ref: ref, loginRepositories: loginRepositories);
});

final fetchUsernameProvider = FutureProvider.autoDispose((ref) {
  final loginRepositories = ref.watch(loginRepositoryProvider);
  return loginRepositories.fetchUsername();
});

class LoginController {
  final ProviderRef ref;
  final LoginRepositories loginRepositories;

  LoginController({required this.ref, required this.loginRepositories});
  final loginStateProvider = StateProvider.autoDispose<LoginModel>((ref) {
    return const LoginModel(userName: '');
  });

  final isValidateUsername = StateProvider.autoDispose<bool>((ref) {
    return false;
  });
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final RoundedLoadingButtonController buttonController =
      RoundedLoadingButtonController();

  setIsValidateUsername(bool val) {
    ref.read(isValidateUsername.state).state = val;
  }

  login(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.home, (Route<dynamic> route) => false);
  }
}
