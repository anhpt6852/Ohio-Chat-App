import 'package:flutter/material.dart';
import 'package:ohio_chat_app/core/commons/presentation/common_button.dart';
import 'package:ohio_chat_app/core/constant/colors.dart';
import 'package:ohio_chat_app/feature/user_profile/presentation/widgets/profile_pic.dart';
import 'package:ohio_chat_app/routes.dart';

import 'widgets/user_profile_info.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ink[0],
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
            ProfilePic(),
            Divider(color: Colors.white),
            UserProfileInfo(),
          ],
        ),
      ),
    );
  }
}
