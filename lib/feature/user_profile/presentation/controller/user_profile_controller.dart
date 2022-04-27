import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_chat_app/feature/user_profile/data/repositories/user_profile_repositories_impl.dart';
import 'package:ohio_chat_app/feature/user_profile/domain/repositories/user_profile_repositories.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

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

  final RoundedLoadingButtonController buttonController =
      RoundedLoadingButtonController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  getCurrentUser() {
    final User user = _firebaseAuth.currentUser!;
    profileNameController.text = user.displayName ?? '';
    profileEmailController.text = user.email ?? '';
  }

  updateCurrentUser() {
    final User user = _firebaseAuth.currentUser!;
    user.updateDisplayName(profileNameController.text);
    user.updateEmail(profileEmailController.text);
    user.updatePhotoURL("");
  }

  displayUserName() {
    final User user = _firebaseAuth.currentUser!;
    final userName = user.displayName.toString();
    return userName;
  }

  displayUserEmail() {
    final User user = _firebaseAuth.currentUser!;
    final userEmail = user.email.toString();
    return userEmail;
  }

  displayUserAva() {
    final User user = _firebaseAuth.currentUser!;
    final userAva = user.photoURL;
    return userAva;
  }
}
