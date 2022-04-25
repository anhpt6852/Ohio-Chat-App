import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_templates/core/commons/presentation/common_loading.dart';
import 'package:ohio_templates/core/commons/presentation/snack_bar.dart';
import 'package:ohio_templates/feature/user_profile/presentation/controller/user_profile_controller.dart';

class UserProfileInfo extends ConsumerWidget {
  const UserProfileInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(fetchUserInfoProvider).when(
        data: ((data) {
          return Column(children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(width: 1.0)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.person_add_alt_1),
                title: Text(data.userName!),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                leading: const Icon(Icons.cake),
                title: Text(data.userDob!),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                leading: const Icon(Icons.map),
                title: Text(data.userCountry!),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                leading: const Icon(Icons.email),
                title: Text(data.userEmail!),
              ),
            ),
          ]);
        }),
        error: (e, stack) => CommonSnackbar.show(context,
            type: SnackbarType.error, message: e.toString()),
        loading: () => const CommonLoading());
  }
}
