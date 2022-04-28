import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_chat_app/core/commons/presentation/common_button.dart';
import 'package:ohio_chat_app/core/commons/presentation/common_text_form_field.dart';
import 'package:ohio_chat_app/core/commons/presentation/snack_bar.dart';
import 'package:ohio_chat_app/core/config/theme.dart';
import 'package:ohio_chat_app/core/constant/colors.dart';
import 'package:ohio_chat_app/feature/login/presentation/controller/login_controller.dart';
import 'package:ohio_chat_app/generated/locale_keys.g.dart';
import 'package:ohio_chat_app/routes.dart';

class LoginForm extends ConsumerWidget {
  LoginForm({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(loginControllerProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 32.0),
            CommonTextFormField(
              labelText: tr(LocaleKeys.login_usernameLabel),
              controller: controller.usernameController,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 8),
            CommonTextFormField(
              labelText: tr(LocaleKeys.login_passwordLabel),
              controller: controller.passwordController,
              textInputAction: TextInputAction.done,
              suffixIcon: GestureDetector(
                onTap: () {
                  ref.read(controller.isObscureText.state).state =
                      !ref.read(controller.isObscureText.state).state;
                },
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: ref.watch(controller.isObscureText)
                        ? const Icon(Icons.visibility_off, size: 24)
                        : const Icon(Icons.visibility, size: 24)),
              ),
              sufflixBoxConstrains:
                  const BoxConstraints(maxHeight: 24, maxWidth: 24),
              obscureText: ref.watch(controller.isObscureText),
            ),
            const SizedBox(height: 16),
            CommonButton(
              child: Text(
                tr(LocaleKeys.login_loginButtonLabel),
                style: t16M,
              ),
              onPressed: () async {
                if (controller.passwordController.text.isEmpty) {
                  CommonSnackbar.show(context,
                      type: SnackbarType.warning,
                      message: tr(LocaleKeys.error_login_empty_password));
                }
                if (controller.usernameController.text.isEmpty) {
                  CommonSnackbar.show(context,
                      type: SnackbarType.warning,
                      message: tr(LocaleKeys.error_login_empty_user));
                } else {
                  var loginRes = await controller.doLogin(
                      email: controller.usernameController.text,
                      password: controller.passwordController.text);
                  if (!loginRes['status']) {
                    CommonSnackbar.show(context,
                        type: SnackbarType.warning,
                        message: tr(LocaleKeys.error_login_wrong_password));
                  } else {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        AppRoutes.home, (route) => false);
                  }
                }

                controller.buttonController.reset();
              },
              btnController: controller.buttonController,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {},
                child: Text(
                  tr(LocaleKeys.login_forget_password_label),
                  style: t14M.apply(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {},
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: tr(LocaleKeys.login_register_label),
                        style: t14M.apply(color: AppColors.ink[400])),
                    const WidgetSpan(child: SizedBox(width: 4)),
                    WidgetSpan(
                        child: GestureDetector(
                            onTap: () => Navigator.pushNamed(
                                context, AppRoutes.register),
                            child: Text(tr(LocaleKeys.login_register_suggest),
                                style: t14M.apply(color: AppColors.primary))))
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
