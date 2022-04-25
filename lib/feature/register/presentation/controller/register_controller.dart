import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_chat_app/core/commons/presentation/snack_bar.dart';
import 'package:ohio_chat_app/feature/register/data/models/register_response.dart';
import 'package:ohio_chat_app/feature/register/data/repositories/register_repositories_impl.dart';
import 'package:ohio_chat_app/feature/register/domain/repositories/register_repositories.dart';
import 'package:ohio_chat_app/feature/register/domain/usecases/register.dart';
import 'package:ohio_chat_app/routes.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

final registerControllerProvider = Provider.autoDispose((ref) {
  final registerRepositories = ref.watch(registerRepositoryProvider);
  return RegisterController(
      ref: ref, registerRepositories: registerRepositories);
});

class RegisterController {
  final ProviderRef ref;
  final RegisterRepositories registerRepositories;

  RegisterController({required this.ref, required this.registerRepositories});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();
  final RoundedLoadingButtonController buttonController =
      RoundedLoadingButtonController();
  //instance Firebase
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  registerWithEmailPassword(
      {required String name,
      required String email,
      required String password}) async {
    try {
      var res = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      print(res);
      res.user?.updateDisplayName(name);
      return {"status": true, "message": "success", "data": res.user};
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      return {"status": false, "message": e.message.toString(), "data": ""};
    }
  }
}
