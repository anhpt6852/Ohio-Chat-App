import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ohio_chat_app/core/config/theme.dart';
import 'package:ohio_chat_app/core/constant/colors.dart';
import 'package:ohio_chat_app/feature/user_profile/presentation/widgets/profile_pic.dart';
import 'package:ohio_chat_app/generated/locale_keys.g.dart';
import 'package:ohio_chat_app/routes.dart';

import 'widgets/user_profile_info.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ink[0],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        title: Text(
          tr(LocaleKeys.profile_title),
          style: t16M.copyWith(
            color: AppColors.ink[500],
          ),
        ),
        actions: [
          IconButton(
              onPressed: () => AppRoutes.userProfileConfig,
              icon: Icon(Icons.edit))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const ProfilePic(),
            Divider(
              color: AppColors.ink[0],
            ),
            const UserProfileInfo(),
          ],
        ),
      ),
    );
  }
}
