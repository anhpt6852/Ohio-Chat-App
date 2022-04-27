import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_chat_app/feature/user_profile/presentation/controller/user_profile_controller.dart';

class ProfilePic extends ConsumerWidget {
  const ProfilePic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(userProfileControllerProvider);
    return SizedBox(
      height: 100,
      width: 100,
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Image.network(
            'https://cdn3.iconfinder.com/data/icons/avatars-round-flat/33/avat-01-512.png'),
      ),
    );
  }
}
