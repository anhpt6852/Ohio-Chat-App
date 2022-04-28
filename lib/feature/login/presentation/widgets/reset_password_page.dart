import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_chat_app/core/commons/presentation/common_button.dart';
import 'package:ohio_chat_app/core/commons/presentation/common_loading.dart';
import 'package:ohio_chat_app/core/commons/presentation/common_text_form_field.dart';
import 'package:ohio_chat_app/core/commons/presentation/snack_bar.dart';
import 'package:ohio_chat_app/core/config/theme.dart';
import 'package:ohio_chat_app/core/constant/colors.dart';
import 'package:ohio_chat_app/feature/login/presentation/controller/login_controller.dart';
import 'package:ohio_chat_app/generated/assets.gen.dart';
import 'package:ohio_chat_app/generated/locale_keys.g.dart';
import 'package:open_mail_app/open_mail_app.dart';

class ResetPasswordPage extends ConsumerWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final controller = ref.watch(loginControllerProvider);

    final appBar = AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        leading: GestureDetector(
            onTap: () {
              ref.read(controller.isSendEmail.state).state = false;
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios)));

    final body = SingleChildScrollView(
        child: Container(
      padding: const EdgeInsets.all(16.0),
      color: AppColors.ink[0],
      child: ref.watch(controller.isSendEmail)
          ? AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Center(
                child: Column(
                  children: [
                    Assets.images.emailPng.image(),
                    const SizedBox(height: 24),
                    Text(tr(LocaleKeys.login_forget_password_check_mail),
                        style: t30M.copyWith(color: AppColors.ink[500])),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 136,
                      child: Text(
                        tr(LocaleKeys
                            .login_forget_password_check_mail_subtitle),
                        style: t14M.copyWith(color: AppColors.ink[400]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CupertinoButton(
                        color: AppColors.primary,
                        child: Text(tr(
                            LocaleKeys.login_forget_password_open_mail_button)),
                        onPressed: () async {
                          await OpenMailApp.openMailApp(
                            nativePickerTitle: tr(LocaleKeys
                                .login_forget_password_open_mail_button),
                          );
                        })
                  ],
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr(LocaleKeys.login_forget_password_title),
                  style: t30M.copyWith(color: AppColors.ink[500]),
                ),
                const SizedBox(height: 16),
                Text(
                  tr(LocaleKeys.login_forget_password_subtitle),
                  style: t16M.copyWith(color: AppColors.ink[400]),
                ),
                const SizedBox(height: 24),
                CommonTextFormField(
                  controller: controller.emailResetController,
                  labelText: tr(LocaleKeys.register_email),
                ),
                const SizedBox(height: 8),
                CommonButton(
                  child: Text(
                    tr(LocaleKeys.login_forget_password_button),
                    style: t16M,
                  ),
                  onPressed: () {
                    if (!controller
                        .isEmail(controller.emailResetController.text)) {
                      CommonSnackbar.show(context,
                          type: SnackbarType.warning,
                          message: tr(LocaleKeys.error_login_invalid_email));
                    } else {
                      controller.resetPassword(
                          context, controller.emailResetController.text);
                    }

                    controller.buttonResetPassController.reset();
                  },
                  btnController: controller.buttonResetPassController,
                ),
              ],
            ),
    ));

    return WillPopScope(
      onWillPop: () async {
        ref.read(controller.isSendEmail.state).state = false;
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.ink[0],
        appBar: appBar,
        body: body,
      ),
    );
  }
}
