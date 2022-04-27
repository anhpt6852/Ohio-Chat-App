import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_chat_app/core/commons/presentation/common_button.dart';
import 'package:ohio_chat_app/core/commons/presentation/common_text_form_field.dart';
import 'package:ohio_chat_app/core/commons/presentation/snack_bar.dart';
import 'package:ohio_chat_app/core/config/theme.dart';
import 'package:ohio_chat_app/core/constant/colors.dart';
import 'package:ohio_chat_app/feature/user_profile/presentation/controller/user_profile_controller.dart';
import 'package:ohio_chat_app/generated/locale_keys.g.dart';

class UserProfileConfig extends ConsumerWidget {
  UserProfileConfig({Key? key}) : super(key: key);

  final _formKeyProfileConfig = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(userProfileControllerProvider);
    controller.getCurrentUser();
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back_ios)),
          centerTitle: true, // Move title to center
          title: Text(
            tr(LocaleKeys.profile_edit),
            style: t16M.copyWith(
              color: AppColors.ink[500],
            ),
          ),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              Stack(
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Image.network(
                        controller.displayUserAva(),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CommonButton(
                      btnController: controller.buttonController,
                      onPressed: () {showDialog(BuildContext context, WidgetRef ref) {
                        return AlertDialog(
                          title: Text(),
                        )
                      } 
                      },
                      child: Icon(Icons.add_a_photo)
                  ))
                ],
              ),
              Divider(
                color: AppColors.ink[0],
              ),
              Container(
                decoration: BoxDecoration(
                    color: AppColors.ink[100],
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(width: 1.2, color: AppColors.ink[0]!)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: CommonTextFormField(
                  labelText: tr(LocaleKeys.profile_name),
                  controller: controller.profileNameController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                ),
              ),
              Divider(
                color: AppColors.ink[0],
              ),
              Container(
                decoration: BoxDecoration(
                    color: AppColors.ink[100], //...
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(width: 1.2, color: AppColors.ink[0]!)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: CommonTextFormField(
                  labelText: tr(LocaleKeys.profile_email),
                  controller: controller.profileEmailController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                ),
              ),
              Divider(
                color: AppColors.ink[0],
              ),
              CommonButton(
                child: Text(tr(LocaleKeys.profile_save), style: t16M),
                onPressed: () async {
                  if (controller.profileNameController.text.isEmpty ||
                      controller.profileEmailController.text.isEmpty) {
                    CommonSnackbar.show(context,
                        type: SnackbarType.warning,
                        message: tr(LocaleKeys.profile_empty_error));
                  } else {
                    controller.updateCurrentUser();
                  }
                },
                btnController: controller.buttonController,
              )
            ])));
  }
}
