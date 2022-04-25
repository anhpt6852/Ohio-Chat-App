import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_templates/core/commons/presentation/common_loading.dart';
import 'package:ohio_templates/core/commons/presentation/snack_bar.dart';
import 'package:ohio_templates/feature/user_profile/presentation/controller/user_profile_controller.dart';

class ProfilePic extends ConsumerWidget {
  const ProfilePic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(fetchUserInfoProvider).when(
        data: ((data) {
          return SizedBox(
            height: 100,
            width: 100,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Image.network(
                data.userAvatar!,
              ),
            ),
          );
        }),
        error: (e, stack) => CommonSnackbar.show(context,
            type: SnackbarType.error, message: e.toString()),
        loading: () => const CommonLoading());
  }
}
