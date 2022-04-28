import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_chat_app/core/commons/presentation/common_button.dart';
import 'package:ohio_chat_app/core/commons/presentation/snack_bar.dart';
import 'package:ohio_chat_app/core/constant/colors.dart';
import 'package:ohio_chat_app/feature/user_profile/presentation/controller/user_profile_controller.dart';
import 'package:ohio_chat_app/generated/locale_keys.g.dart';
import 'package:ohio_chat_app/routes.dart';

class UserProfileInfo extends ConsumerWidget {
  const UserProfileInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(userProfileControllerProvider);
    return Column(children: [
      Divider(
        color: AppColors.ink[0],
      ),
      Container(
        decoration: BoxDecoration(
            color: AppColors.ink[100], //...
            borderRadius: BorderRadius.circular(24),
            border: Border.all(width: 1.2, color: AppColors.ink[0]!)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          leading: const Icon(Icons.person_add_alt_1),
          title: Text(data.displayUserName()),
        ),
      ),
      Divider(
        color: AppColors.ink[0],
      ),
      Container(
        decoration: BoxDecoration(
            color: AppColors.ink[100],
            borderRadius: BorderRadius.circular(24),
            border: Border.all(width: 1.2, color: AppColors.ink[0]!)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          leading: const Icon(Icons.email),
          title: Text(data.displayUserEmail()),
        ),
      ),
      Divider(
        color: AppColors.ink[0],
      ),
      CommonButton(
          child: Text(tr(LocaleKeys.config_logout)),
          btnController: data.buttonController,
          onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: const Text(LocaleKeys.confirmation_logout,
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      content: Row(
                        children: [
                          TextButton(
                              onPressed: () {
                                data.logoutUser();
                                if (data.isLogoutSuccessfully) {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      AppRoutes.login, (route) => false);
                                } else {
                                  CommonSnackbar.show(context,
                                      type: SnackbarType.error,
                                      message: 'Logout failed');
                                }
                              },
                              child: const Text('Yes')),
                          VerticalDivider(color: AppColors.ink[0]),
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('No'))
                        ],
                      ));
                },
              )),
    ]);
  }
}
