import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_chat_app/core/commons/presentation/common_button.dart';
import 'package:ohio_chat_app/core/commons/presentation/common_loading.dart';
import 'package:ohio_chat_app/core/commons/presentation/common_text_form_field.dart';
import 'package:ohio_chat_app/core/config/theme.dart';
import 'package:ohio_chat_app/core/constant/colors.dart';
import 'package:ohio_chat_app/feature/register/presentation/controller/register_controller.dart';
import 'package:ohio_chat_app/generated/locale_keys.g.dart';

class RegisterPage extends ConsumerWidget {
  RegisterPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(registerControllerProvider);

    final appBar = AppBar(
        title: Text(tr(LocaleKeys.register_title),
            style: t16M.copyWith(color: AppColors.ink[500])),
        centerTitle: true,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios)));

    final body = Container(
        color: AppColors.ink[0],
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(children: [
            ref.watch(controller.isImageLoading) == true
                ? const SizedBox(
                    height: 112,
                    width: 112,
                    child: Center(child: CommonLoading()))
                : GestureDetector(
                    onTap: () {
                      controller.getImage();
                    },
                    child: ref.watch(controller.imageUrl) == ''
                        ? Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: CircleAvatar(
                                  radius: 48,
                                  backgroundColor: AppColors.ink[300],
                                  child: Icon(
                                    Icons.person,
                                    color: AppColors.ink[0],
                                    size: 56,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(
                                      color: AppColors.ink[0],
                                      shape: BoxShape.circle),
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: AppColors.ink[300],
                                    size: 24,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Image.network(
                            ref.watch(controller.imageUrl),
                            width: 112,
                            height: 112,
                            fit: BoxFit.contain,
                          ),
                  ),
            const SizedBox(height: 24),
            CommonTextFormField(
              height: 52,
              hintText: tr(LocaleKeys.register_fullname),
              controller: controller.usernameController,
              prefixIcon: const Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(Icons.person, size: 24)),
              prefixBoxConstrains:
                  const BoxConstraints(maxHeight: 24, maxWidth: 32),
              validator: (str) {
                if (str == null || str.isEmpty) {
                  return tr(LocaleKeys.error_empty_error);
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            CommonTextFormField(
              height: 52,
              hintText: tr(LocaleKeys.register_email),
              controller: controller.emailController,
              prefixIcon: const Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(Icons.email, size: 24)),
              prefixBoxConstrains:
                  const BoxConstraints(maxHeight: 24, maxWidth: 32),
              validator: (str) {
                if (str == null || str.isEmpty) {
                  return tr(LocaleKeys.error_empty_error);
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            CommonTextFormField(
              height: 52,
              hintText: tr(LocaleKeys.register_password),
              controller: controller.passwordController,
              obscureText: true,
              prefixIcon: const Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(Icons.lock, size: 24)),
              prefixBoxConstrains:
                  const BoxConstraints(maxHeight: 24, maxWidth: 32),
              validator: (str) {
                if (str == null || str.isEmpty) {
                  return tr(LocaleKeys.error_empty_error);
                }
                if (str.length < 6) {
                  return tr(LocaleKeys.error_short_password);
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            CommonTextFormField(
              height: 52,
              hintText: tr(LocaleKeys.register_re_password),
              controller: controller.rePasswordController,
              obscureText: true,
              prefixIcon: const Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(Icons.lock, size: 24)),
              prefixBoxConstrains:
                  const BoxConstraints(maxHeight: 24, maxWidth: 32),
              validator: (str) {
                if (str == null || str.isEmpty) {
                  return tr(LocaleKeys.error_empty_error);
                }
                if (str.length < 6) {
                  return tr(LocaleKeys.error_short_password);
                }
                if (controller.rePasswordController.text !=
                    controller.passwordController.text) {
                  return tr(LocaleKeys.error_not_same_password);
                }
                return null;
              },
            ),
          ]),
        ));

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          Scaffold(
            appBar: appBar,
            body: body,
          ),
          Positioned(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CommonButton(
                child: Text(
                  tr(LocaleKeys.register_button_label),
                  style: t16M,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    controller.registerWithEmailPassword(context,
                        password: controller.passwordController.text,
                        email: controller.emailController.text,
                        name: controller.usernameController.text);
                  } else {
                    controller.buttonController.reset();
                  }
                },
                btnController: controller.buttonController,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
