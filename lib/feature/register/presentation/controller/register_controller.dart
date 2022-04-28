import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ohio_chat_app/core/commons/presentation/snack_bar.dart';
import 'package:ohio_chat_app/core/constant/firestore_constants.dart';
import 'package:ohio_chat_app/feature/chat/data/models/chat_user.dart';
import 'package:ohio_chat_app/feature/register/data/models/register_response.dart';
import 'package:ohio_chat_app/feature/register/data/repositories/register_repositories_impl.dart';
import 'package:ohio_chat_app/feature/register/domain/repositories/register_repositories.dart';
import 'package:ohio_chat_app/feature/register/domain/usecases/register.dart';
import 'package:ohio_chat_app/routes.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

final registerControllerProvider = Provider.autoDispose((ref) {
  final registerRepositories = ref.watch(registerRepositoryProvider);
  return RegisterController(
      ref: ref, registerRepositories: registerRepositories);
});

class RegisterController {
  final ProviderRef ref;
  final RegisterRepositories registerRepositories;

  RegisterController({required this.ref, required this.registerRepositories});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();
  final RoundedLoadingButtonController buttonController =
      RoundedLoadingButtonController();
  //instance Firebase
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseStorage = FirebaseStorage.instance;

  var imageUrl = StateProvider((ref) => '');
  var isImageLoading = StateProvider((ref) => false);

  registerWithEmailPassword(context,
      {required String name,
      required String email,
      required String password}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var res = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      await res.user?.updateDisplayName(name);
      print(res);
      var firebaseUser = res.user!;
      final QuerySnapshot data = await firebaseFirestore
          .collection(FirestoreConstants.pathUserCollection)
          .where(FirestoreConstants.id, isEqualTo: firebaseUser.uid)
          .get();
      final List<DocumentSnapshot> document = data.docs;
      if (document.isEmpty) {
        firebaseFirestore
            .collection(FirestoreConstants.pathUserCollection)
            .doc(firebaseUser.uid)
            .set({
          FirestoreConstants.displayName: name,
          FirestoreConstants.photoUrl: firebaseUser.photoURL,
          FirestoreConstants.id: firebaseUser.uid,
          "createdAt: ": DateTime.now().millisecondsSinceEpoch.toString(),
          FirestoreConstants.chattingWith: null
        });

        User? currentUser = firebaseUser;
        await prefs.setString(FirestoreConstants.id, currentUser.uid);
        await prefs.setString(
            FirestoreConstants.displayName, currentUser.displayName ?? "");
        await prefs.setString(
            FirestoreConstants.photoUrl, currentUser.photoURL ?? "");
        await prefs.setString(
            FirestoreConstants.phoneNumber, currentUser.phoneNumber ?? "");
      } else {
        DocumentSnapshot documentSnapshot = document[0];
        ChatUser userChat = ChatUser.fromDocument(documentSnapshot);
        await prefs.setString(FirestoreConstants.id, userChat.id);
        await prefs.setString(
            FirestoreConstants.displayName, userChat.displayName);
        await prefs.setString(FirestoreConstants.aboutMe, userChat.aboutMe);
        await prefs.setString(
            FirestoreConstants.phoneNumber, userChat.phoneNumber);
      }
      buttonController.reset();
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
      return {"status": true, "message": "success", "data": res.user};
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      CommonSnackbar.show(context,
          type: SnackbarType.error, message: e.message!);
      buttonController.reset();

      return {"status": false, "message": e.message.toString(), "data": ""};
    }
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile;
    pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      var imageFile = File(pickedFile.path);
      try {
        ref.read(isImageLoading.state).state = true;
        TaskSnapshot snapshot = await uploadImageFile(
            imageFile, DateTime.now().millisecondsSinceEpoch.toString());
        ref.read(imageUrl.state).state = await snapshot.ref.getDownloadURL();
        ref.read(isImageLoading.state).state = false;
      } catch (e) {
        ref.read(isImageLoading.state).state = false;
      }
    }
  }

  UploadTask uploadImageFile(File image, String filename) {
    Reference reference = firebaseStorage.ref().child(filename);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }
}
