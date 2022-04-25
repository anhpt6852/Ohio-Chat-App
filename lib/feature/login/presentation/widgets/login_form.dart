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
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(loginControllerProvider);
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            decoration: BoxDecoration(
              color: AppColors.ink[100],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            child: SafeArea(
                child: SizedBox(
                    width: double.infinity,
                    child: SafeArea(
                      top: false,
                      left: false,
                      right: false,
                      child: Consumer(
                        builder: (BuildContext context, WidgetRef ref,
                            Widget? child) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
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
                                AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 500),
                                    transitionBuilder: (Widget child,
                                            Animation<double> animation) =>
                                        SizeTransition(
                                            child: child,
                                            sizeFactor: animation),
                                    child: ref
                                            .watch(controller
                                                .isValidateUsername.state)
                                            .state
                                        ? Column(
                                            children: [
                                              const SizedBox(height: 16),
                                              CommonTextFormField(
                                                labelText: tr(LocaleKeys
                                                    .login_passwordLabel),
                                                controller: controller
                                                    .passwordController,
                                                textInputAction:
                                                    TextInputAction.done,
                                                obscureText: true,
                                                onChanged: (str) {},
                                                onFieldSubmitted: (_) {},
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: GestureDetector(
                                                  onTap: () {},
                                                  child: Text(
                                                    tr(LocaleKeys
                                                        .login_forget_password_label),
                                                    style: t16M.apply(
                                                        color:
                                                            AppColors.primary),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : const SizedBox.shrink()),
                                const SizedBox(height: 16),
                                CommonButton(
                                  child: Text(
                                    tr(LocaleKeys.login_loginButtonLabel),
                                    style: t16M,
                                  ),
                                  onPressed: () async {
                                    if (ref
                                        .read(
                                            controller.isValidateUsername.state)
                                        .state) {
                                      if (await controller.checkUserExisted(
                                          controller.usernameController.text)) {
                                        controller.setIsValidateUsername(true);
                                      } else {
                                        CommonSnackbar.show(context,
                                            type: SnackbarType.warning,
                                            message: tr(LocaleKeys
                                                .error_login_invalid_user));
                                      }
                                    } else {
                                      CommonSnackbar.show(context,
                                          type: SnackbarType.warning,
                                          message: tr(LocaleKeys
                                              .error_login_invalid_email));
                                    }

                                    if (controller
                                        .passwordController.text.isNotEmpty) {
                                      var loginRes = await controller.doLogin(
                                          email: controller
                                              .usernameController.text,
                                          password: controller
                                              .passwordController.text);
                                      if (!loginRes['status']) {
                                        CommonSnackbar.show(context,
                                            type: SnackbarType.warning,
                                            message: tr(LocaleKeys
                                                .error_login_wrong_password));
                                      } else {
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                AppRoutes.home,
                                                (route) => false);
                                      }
                                    } else {
                                      CommonSnackbar.show(context,
                                          type: SnackbarType.warning,
                                          message: tr(LocaleKeys
                                              .error_login_empty_password));
                                    }

                                    controller.buttonController.reset();
                                  },
                                  btnController: controller.buttonController,
                                ),
                                const SizedBox(height: 16),
                                AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 500),
                                    transitionBuilder: (Widget child,
                                            Animation<double> animation) =>
                                        SizeTransition(
                                            child: child,
                                            sizeFactor: animation),
                                    child: ref
                                            .watch(controller
                                                .isValidateUsername.state)
                                            .state
                                        ? const SizedBox.shrink()
                                        : Align(
                                            alignment: Alignment.center,
                                            child: GestureDetector(
                                              onTap: () {},
                                              child: RichText(
                                                text: TextSpan(children: [
                                                  TextSpan(
                                                      text: tr(LocaleKeys
                                                          .login_register_label),
                                                      style: t14M.apply(
                                                          color: AppColors
                                                              .ink[400])),
                                                  const WidgetSpan(
                                                      child:
                                                          SizedBox(width: 4)),
                                                  WidgetSpan(
                                                      child: GestureDetector(
                                                          onTap: () => Navigator
                                                              .pushNamed(
                                                                  context,
                                                                  AppRoutes
                                                                      .register),
                                                          child: Text(
                                                              tr(LocaleKeys
                                                                  .login_register_suggest),
                                                              style: t14M.apply(
                                                                  color: AppColors
                                                                      .primary))))
                                                ]),
                                              ),
                                            ),
                                          )),
                                const SizedBox(height: 16),
                              ],
                            ),
                          );
                        },
                      ),
                    )))));
  }
}
