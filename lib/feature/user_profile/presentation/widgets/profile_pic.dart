import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_chat_app/feature/user_profile/presentation/controller/user_profile_controller.dart';

class ProfilePic extends ConsumerWidget {
  const ProfilePic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(userProfileControllerProvider);

    return SizedBox(
      height: 100,
      width: 100,
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Image.network(controller.displayUserAva()),
      ),
    );
  }
}
