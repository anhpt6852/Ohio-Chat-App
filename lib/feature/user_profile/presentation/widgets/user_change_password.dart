import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_chat_app/core/commons/presentation/common_button.dart';
import 'package:ohio_chat_app/core/commons/presentation/common_text_form_field.dart';
import 'package:ohio_chat_app/core/config/theme.dart';
import 'package:ohio_chat_app/core/constant/colors.dart';
import 'package:ohio_chat_app/feature/user_profile/presentation/controller/user_profile_controller.dart';
import 'package:ohio_chat_app/generated/locale_keys.g.dart';

class ChangePassword extends ConsumerWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(userProfileControllerProvider);
    return Scaffold(
        backgroundColor: AppColors.ink[0],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back_ios)),
          centerTitle: true,
          title: Text(
            tr(LocaleKeys.profile_change_password),
            style: t16M.copyWith(
              color: AppColors.ink[500],
            ),
          ),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              CommonTextFormField(
                labelText: tr(LocaleKeys.profile_current_password),
                controller: controller.profilePasswordController,
                textInputAction: TextInputAction.done,
                obscureText: true,
              ),
              Divider(
                color: AppColors.ink[0],
              ),
              CommonTextFormField(
                labelText: tr(LocaleKeys.profile_new_password),
                controller: controller.profilePasswordNewController,
                textInputAction: TextInputAction.done,
                obscureText: true,
              ),
              Divider(
                color: AppColors.ink[0],
              ),
              CommonTextFormField(
                labelText: tr(LocaleKeys.profile_confirm_new_password),
                controller: controller.profilePasswordNewConfirmController,
                textInputAction: TextInputAction.done,
                obscureText: true,
              ),
              Divider(
                color: AppColors.ink[0],
              ),
              CommonButton(
                  onPressed: () {
                    controller.changePassword(context);
                  },
                  btnController: controller.buttonController)
            ])));
  }
}
