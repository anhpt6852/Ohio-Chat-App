import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nanoid/async.dart';
import 'package:ohio_chat_app/core/commons/presentation/snack_bar.dart';
import 'package:ohio_chat_app/core/constant/firestore_constants.dart';
import 'package:ohio_chat_app/feature/social/data/models/comments.dart';
import 'package:ohio_chat_app/feature/social/data/models/newfeeds.dart';
import 'package:ohio_chat_app/generated/locale_keys.g.dart';

final socialControllerProvider = Provider.autoDispose((ref) {
  return SocialController(ref);
});

class SocialController {
  final ProviderRef ref;

  SocialController(this.ref);

  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseStorage = FirebaseStorage.instance;

  final TextEditingController postController = TextEditingController();
  final imageUrl = StateProvider<String>((ref) => '');
  final imageCommentsUrl = StateProvider<String>((ref) => '');
  final isUploadImg = StateProvider<bool>((ref) => false);

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future getImage(StateProvider<String> url) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile;
    pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      var imageFile = File(pickedFile.path);
      ref.read(isUploadImg.state).state = true;
      TaskSnapshot snapshot = await uploadImageFile(
          imageFile, DateTime.now().millisecondsSinceEpoch.toString());
      ref.read(url.state).state = await snapshot.ref.getDownloadURL();
      ref.read(isUploadImg.state).state = false;
    }
  }

  UploadTask uploadImageFile(File image, String filename) {
    Reference reference = firebaseStorage.ref().child(filename);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }

  Stream<QuerySnapshot> getNewfeeds(int limit) {
    var data = firebaseFirestore
        .collection(FirestoreConstants.pathNewfeedsCollection)
        .limit(limit)
        .orderBy('timestamp', descending: true)
        .snapshots();
    print(data);

    return data;
  }

  Stream<DocumentSnapshot> getNewfeedsDetail(String postId) {
    var data = firebaseFirestore
        .collection(FirestoreConstants.pathNewfeedsCollection)
        .doc(postId)
        .snapshots();
    print(data);

    return data;
  }

  Stream<DocumentSnapshot> getUser(String uid) {
    var data = firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .doc(uid)
        .snapshots();
    print(data);

    return data;
  }

  Stream<QuerySnapshot> getComments(String postId) {
    var data = firebaseFirestore
        .collection(FirestoreConstants.pathNewfeedsCollection)
        .doc(FirestoreConstants.comments)
        .collection(postId)
        .orderBy(FirestoreConstants.timestamp, descending: true)
        .snapshots();
    print(data);

    return data;
  }

  String displayUserId() {
    final User user = _firebaseAuth.currentUser!;
    final userName = user.uid;
    return userName;
  }

  bool checkReactPost(List react) {
    if (react.contains(displayUserId())) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteComments(
      String postId, String commentId, List comments) async {
    try {
      comments.remove(commentId);
      firebaseFirestore
          .collection(FirestoreConstants.pathNewfeedsCollection)
          .doc(FirestoreConstants.comments)
          .collection(postId)
          .doc(commentId)
          .delete();
      firebaseFirestore
          .collection(FirestoreConstants.pathNewfeedsCollection)
          .doc(postId)
          .update({"comments": comments});
      return true;
    } catch (e) {
      return false;
    }
  }

  LinearGradient colorPost(listColor) {
    var color = LinearGradient(colors: [
      Color.fromRGBO(255, listColor[1], listColor[2], 1),
      Color.fromRGBO(255, listColor[4], listColor[5], 1),
    ]);

    return color;
  }

  reactPost(String postId, List react) {
    if (react.contains(displayUserId())) {
      react.remove(displayUserId());
    } else {
      react.add(displayUserId());
    }
    firebaseFirestore
        .collection(FirestoreConstants.pathNewfeedsCollection)
        .doc(postId)
        .update({'react': react});
  }

  Stream<QuerySnapshot> getDataUser() {
    var user = firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .snapshots();
    print(user);
    return user;
  }

  void createNewPost(context, String content) async {
    if (postController.text.isEmpty || postController.text.trim() == '') {
      CommonSnackbar.show(context,
          type: SnackbarType.error, message: tr(LocaleKeys.error_empty_error));
    } else {
      FirebaseAuth user = FirebaseAuth.instance;
      DocumentReference documentReference = firebaseFirestore
          .collection(FirestoreConstants.pathNewfeedsCollection)
          .doc(await nanoid(30));
      Newfeeds newfeeds = Newfeeds(
          timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
          content: content,
          image: ref.read(imageUrl.state).state,
          comments: [],
          id: user.currentUser!.uid,
          react: [],
          color: [
            Random().nextInt(255),
            Random().nextInt(255),
            Random().nextInt(255),
            Random().nextInt(255),
            Random().nextInt(255),
            Random().nextInt(255)
          ]);

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(documentReference, newfeeds.toJson());
      });
      postController.clear();
      Navigator.of(context).pop();
    }
  }

  void commentPost(String content, String postId, List listComments) async {
    FirebaseAuth user = FirebaseAuth.instance;

    Comments comments = Comments(
      timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      image: ref.read(imageCommentsUrl.state).state,
      id: user.currentUser!.uid,
    );

    DocumentReference documentReference = firebaseFirestore
        .collection(FirestoreConstants.pathNewfeedsCollection)
        .doc(FirestoreConstants.comments)
        .collection(postId)
        .doc(await nanoid(20));

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(documentReference, comments.toJson());
    });

    listComments.add(documentReference.id);

    firebaseFirestore
        .collection(FirestoreConstants.pathNewfeedsCollection)
        .doc(postId)
        .update({FirestoreConstants.comments: listComments});
  }

  Future<bool> deletePost(String postId) async {
    try {
      await firebaseFirestore
          .collection(FirestoreConstants.pathNewfeedsCollection)
          .doc(postId)
          .delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  getTimeOfLastSeen(String timestamp) {
    var time = DateTime.fromMillisecondsSinceEpoch(
      int.parse(timestamp),
    );

    var timeDiffrence = DateTime.now().difference(time).inHours;
    print(timeDiffrence);
    if (timeDiffrence > 24) {
      return DateTime.now()
              .difference(DateTime.fromMillisecondsSinceEpoch(
                int.parse(timestamp),
              ))
              .inDays
              .toString() +
          ' ' +
          tr(LocaleKeys.chat_bf_day);
    }
    if (timeDiffrence < 1) {
      return DateTime.now()
              .difference(DateTime.fromMillisecondsSinceEpoch(
                int.parse(timestamp),
              ))
              .inMinutes
              .toString() +
          ' ' +
          tr(LocaleKeys.chat_bf_minute);
    } else {
      return timeDiffrence.toString() + ' ' + tr(LocaleKeys.chat_bf_hour);
    }
  }
}
