import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_chat_app/feature/user_profile/data/repositories/user_profile_repositories_impl.dart';
import 'package:ohio_chat_app/feature/user_profile/domain/repositories/user_profile_repositories.dart';

final userProfileControllerProvider = Provider.autoDispose((ref) {
  final userProfileRepositories = ref.watch(userProfileRepositoryProvider);
  return UserProfileController(
      ref: ref, userProfileRepositories: userProfileRepositories);
});

final fetchUserInfoProvider = FutureProvider.autoDispose((ref) {
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  return userProfileRepository.fetchUserInfo();
});

class UserProfileController {
  final ProviderRef ref;
  final UserProfileRepositories userProfileRepositories;

  UserProfileController(
      {required this.ref, required this.userProfileRepositories});

  final profileNameController = TextEditingController();
  final profileEmailController = TextEditingController();
  final profileCountryController = TextEditingController();
  // final profileDobController =

}
