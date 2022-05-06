import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_chat_app/core/commons/presentation/common_button.dart';
import 'package:ohio_chat_app/core/commons/presentation/snack_bar.dart';
import 'package:ohio_chat_app/core/config/theme.dart';
import 'package:ohio_chat_app/core/constant/colors.dart';
import 'package:ohio_chat_app/feature/user_profile/presentation/controller/user_profile_controller.dart';
import 'package:ohio_chat_app/generated/locale_keys.g.dart';
import 'package:ohio_chat_app/routes.dart';

class UserProfileDrawer extends ConsumerWidget {
  const UserProfileDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(userProfileControllerProvider);
    return Drawer(
        child: SafeArea(
      child: Column(children: <Widget>[
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(height: 48),
                    SizedBox(
                      width: 112,
                      height: 112,
                      child: CircleAvatar(
                        backgroundImage: controller.displayUserAva() == ''
                            ? null
                            : NetworkImage(controller.displayUserAva()),
                        backgroundColor: AppColors.ink[400],
                        child: controller.displayUserAva() == ''
                            ? Icon(
                                Icons.person,
                                color: AppColors.ink[0],
                                size: 72,
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.displayUserName(),
                      style: t20M,
                    ),
                    Text(
                      controller.displayUserEmail(),
                      style: t14M.copyWith(color: AppColors.ink[400]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Divider(
                thickness: 1,
                color: AppColors.ink[100],
              ),
              ListTile(
                title: Text(tr(LocaleKeys.profile_edit)),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(AppRoutes.userProfileConfig);
                },
              ),
              Divider(
                thickness: 1,
                color: AppColors.ink[100],
              ),
              ListTile(
                title: Text(tr(LocaleKeys.profile_change_password)),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(AppRoutes.changePassword);
                },
              ),
              Divider(
                thickness: 1,
                color: AppColors.ink[100],
              ),
              ListTile(
                title: Text(tr(LocaleKeys.chooseLanguage)),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(AppRoutes.language);
                },
              ),
              Divider(
                thickness: 1,
                color: AppColors.ink[100],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: CommonButton(
              child: Text(tr(LocaleKeys.config_logout)),
              onPressed: () async {
                var logoutRes = await controller.logoutUser();
                if (logoutRes) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.login, (route) => false);
                } else {
                  CommonSnackbar.show(context,
                      type: SnackbarType.error,
                      message: tr(LocaleKeys.profile_error_logout));
                }
              },
              btnController: controller.buttonController),
        ),
      ]),
    ));
  }
}
