import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_chat_app/core/commons/presentation/common_button.dart';
import 'package:ohio_chat_app/core/commons/presentation/snack_bar.dart';
import 'package:ohio_chat_app/feature/user_profile/presentation/controller/user_profile_controller.dart';
import 'package:ohio_chat_app/generated/locale_keys.g.dart';
import 'package:ohio_chat_app/routes.dart';

class UserProfileDrawer extends ConsumerWidget {
  const UserProfileDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(userProfileControllerProvider);
    return Drawer(
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
      SizedBox(
        width: 250,
        height: 250,
        child: DrawerHeader(
            child: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Image.network(controller.displayUserAva()),
        )),
      ),
      ListTile(
        leading: const Icon(Icons.person),
        title: Text(controller.displayUserName()),
        onTap: () {},
      ),
      ListTile(
        leading: const Icon(Icons.email),
        title: Text(controller.displayUserEmail()),
        onTap: () {},
      ),
      ListTile(
        leading: const Icon(Icons.edit),
        title: Text(tr(LocaleKeys.profile_edit)),
        onTap: () {
          Navigator.of(context).pushNamed(AppRoutes.userProfileConfig);
        },
      ),
      ListTile(
        leading: const Icon(Icons.lock),
        title: Text(tr(LocaleKeys.profile_change_password)),
        onTap: () {},
      ),
      Expanded(child: Container()), // Tao khoang trong de Logout Button o cuoi
      CommonButton(
          padding: const EdgeInsets.all(16.0),
          onPressed: () {
            controller.logoutUser();
            if (controller.isLogoutSuccessfully) {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
            } else {
              CommonSnackbar.show(context,
                  type: SnackbarType.error, message: 'Logout failed');
            }
          },
          btnController: controller.buttonController)
    ]));
  }
}
