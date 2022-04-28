import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  final firebaseStorage = FirebaseStorage.instance;

  var isLogoutSuccessfully = false;
  var imageUrl = StateProvider((ref) => '');

  getUserName() {
    final User user = _firebaseAuth.currentUser!;
    profileNameController.text = user.displayName ?? '';
  }

  getUserEmail() {
    final User user = _firebaseAuth.currentUser!;
    profileEmailController.text = user.email ?? '';
  }

  updateUserName() async {
    final User user = _firebaseAuth.currentUser!;
    await user.updateDisplayName(profileNameController.text);
  }

  updateUserEmail() async {
    final User user = _firebaseAuth.currentUser!;
    await user.updateEmail(profileEmailController.text);
  }

  String displayUserName() {
    final User user = _firebaseAuth.currentUser!;
    final userName = user.displayName.toString();
    return userName;
  }

  String displayUserEmail() {
    final User user = _firebaseAuth.currentUser!;
    final userEmail = user.email.toString();
    return userEmail;
  }

  String displayUserAva() {
    final User user = _firebaseAuth.currentUser!;
    final userAva = user.photoURL ?? '';
    return userAva;
  }

  logoutUser() {
    try {
      final User user = _firebaseAuth.currentUser!;
      FirebaseAuth.instance.signOut();

      isLogoutSuccessfully = true;
    } catch (e) {
      isLogoutSuccessfully = false;
    }
  }

  File imageFile = File('');

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile;
    pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      TaskSnapshot snapshot = await uploadImageFile(
          imageFile, DateTime.now().millisecondsSinceEpoch.toString());
      ref.read(imageUrl.state).state = await snapshot.ref.getDownloadURL();
    }
  }

  UploadTask uploadImageFile(File image, String filename) {
    Reference reference = firebaseStorage.ref().child(filename);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }

  updateAvatar() {
    final User user = _firebaseAuth.currentUser!;
    if (ref.read(imageUrl.state).state != '') {
      user.updatePhotoURL(ref.read(imageUrl.state).state);
    }
  }
}
