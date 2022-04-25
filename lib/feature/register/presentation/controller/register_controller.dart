import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_chat_app/core/commons/presentation/snack_bar.dart';
import 'package:ohio_chat_app/core/services/logger.dart';
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
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();
  final RoundedLoadingButtonController buttonController =
      RoundedLoadingButtonController();

  doRegister(context,
      {required String phoneNumber,
      required String password,
      required String email,
      required String fullname}) async {
    try {
      var result = await ref.read(registerProvider(
          phoneNumber: phoneNumber,
          password: password,
          email: email,
          fullname: fullname)) as RegisterResponse;

      CommonSnackbar.show(context,
          message: result.msg, type: SnackbarType.success);
      buttonController.reset();

      Navigator.of(context).pushNamed(AppRoutes.verify);
    } catch (e) {
      buttonController.reset();
      if (e is DioError) {
        CommonSnackbar.show(context,
            message: e.response!.data['msg'], type: SnackbarType.error);
      }
    }
  }
}
