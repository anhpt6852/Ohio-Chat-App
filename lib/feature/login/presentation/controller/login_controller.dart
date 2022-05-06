import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_chat_app/core/commons/presentation/snack_bar.dart';
import 'package:ohio_chat_app/core/constant/firestore_constants.dart';
import 'package:ohio_chat_app/feature/chat/data/models/chat_user.dart';
import 'package:ohio_chat_app/feature/login/data/repositories/login_repositories_impl.dart';
import 'package:ohio_chat_app/feature/login/domain/repositories/login_repositories.dart';
import 'package:ohio_chat_app/routes.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

final loginControllerProvider = Provider.autoDispose((ref) {
  final loginRepositories = ref.watch(loginRepositoryProvider);
  return LoginController(ref: ref, loginRepositories: loginRepositories);
});

final fetchUsernameProvider = FutureProvider.autoDispose((ref) {
  final loginRepositories = ref.watch(loginRepositoryProvider);
  return loginRepositories.fetchUsername();
});

class LoginController {
  final ProviderRef ref;
  final LoginRepositories loginRepositories;

  LoginController({required this.ref, required this.loginRepositories});

  final isValidateUsername = StateProvider.autoDispose<bool>((ref) {
    return false;
  });

  final isLogined = StateProvider.autoDispose<bool>((ref) {
    return false;
  });

  var isObscureText = StateProvider((ref) => true);
  var isSendEmail = StateProvider((ref) => false);

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final RoundedLoadingButtonController buttonController =
      RoundedLoadingButtonController();

  final emailResetController = TextEditingController();
  final RoundedLoadingButtonController buttonResetPassController =
      RoundedLoadingButtonController();
  //instance Firebase
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;

  setIsValidateUsername(bool val) {
    ref.read(isValidateUsername.state).state = val;
  }

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(p);

    return regExp.hasMatch(em);
  }

  checkUserExisted(String email) async {
    var emailExists = await _firebaseAuth.fetchSignInMethodsForEmail(email);
    var isExist = emailExists.isEmpty ? false : true;
    return isExist;
  }

  resetPassword(context, String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      ref.read(isSendEmail.state).state = true;
      emailResetController.clear();
    } on FirebaseAuthException catch (e) {
      CommonSnackbar.show(context,
          type: SnackbarType.error, message: e.message!);
    }
  }

  checkLogin(context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('usernameFirebase');
    var password = prefs.getString('passwordFirebase');
    if (username != null &&
        password != null &&
        username != '' &&
        password != '') {
      usernameController.text = username;
      passwordController.text = password;
      await doLogin(context, email: username, password: password);
    }
  }

  doLogin(context, {required String email, required String password}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      if (!ref.read(isLogined)) {
        var result = await _firebaseAuth.signInWithEmailAndPassword(
            email: email.trim(), password: password.trim());
        print(result.user);
        var firebaseUser = result.user!;
        await prefs.setString('usernameFirebase', email.trim());
        await prefs.setString('passwordFirebase', password.trim());

        var deviceToken = await FirebaseMessaging.instance.getToken();

        print('deviceToken: ' + deviceToken!);

        final QuerySnapshot data = await firebaseFirestore
            .collection(FirestoreConstants.pathUserCollection)
            .where(FirestoreConstants.id, isEqualTo: firebaseUser.uid)
            .get();

        await firebaseFirestore
            .collection(FirestoreConstants.pathUserCollection)
            .doc(firebaseUser.uid)
            .update({"deviceToken": deviceToken});

        final List<DocumentSnapshot> document = data.docs;
        if (document.isEmpty) {
          firebaseFirestore
              .collection(FirestoreConstants.pathUserCollection)
              .doc(firebaseUser.uid)
              .set({
            FirestoreConstants.displayName: firebaseUser.displayName,
            FirestoreConstants.photoUrl: firebaseUser.photoURL,
            FirestoreConstants.id: firebaseUser.uid,
            "createdAt: ": DateTime.now().millisecondsSinceEpoch.toString(),
            FirestoreConstants.chattingWith: null,
            "deviceToken": deviceToken
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
        ref.read(isLogined.state).state = true;

        try {
          RemoteMessage? initialMessage =
              await FirebaseMessaging.instance.getInitialMessage();
        } catch (e) {}
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);

        return {"status": true, "message": "success", "data": result.user};
      }
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      CommonSnackbar.show(context,
          type: SnackbarType.error, message: e.message!);
      buttonController.reset();
      return {"status": false, "message": e.message.toString(), "data": ""};
    }
  }
}
