import 'package:easy_localization/easy_localization.dart';
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
    final controller = ref.watch(userProfileControllerProvider);
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
          title: Text(controller.displayUserName()),
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
          title: Text(controller.displayUserEmail()),
        ),
      ),
      Divider(
        color: AppColors.ink[0],
      ),
      CommonButton(
          child: Text(tr(LocaleKeys.config_logout)),
          btnController: controller.buttonController,
          onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: const Text(LocaleKeys.confirmation_logout,
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      content: Row(
                        children: [
                          TextButton(
                              onPressed: () {}, child: const Text('Yes')),
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
