import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_chat_app/feature/login/data/models/login_model.dart';
import 'package:ohio_chat_app/feature/login/data/repositories/login_repositories_impl.dart';
import 'package:ohio_chat_app/feature/login/domain/repositories/login_repositories.dart';
import 'package:ohio_chat_app/routes.dart';
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

  //instance Firebase
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  setIsValidateUsername(bool val) {
    ref.read(isValidateUsername.state).state = val;
  }

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(p);

    return regExp.hasMatch(em);
  }

  checkUserExisted(String email) async {
    var emailExists = await _firebaseAuth.fetchSignInMethodsForEmail(email);
    var isExist = emailExists.isEmpty ? false : true;
    return isExist;
  }

  doLogin({required String email, required String password}) async {
    try {
      var result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      print(result.user);
      return {"status": true, "message": "success", "data": result.user};
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      return {"status": false, "message": e.message.toString(), "data": ""};
    }
  }
}
