import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_chat_app/core/constant/firestore_constants.dart';
import 'package:ohio_chat_app/feature/chat/data/models/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

final messageControllerProvider = Provider.autoDispose((ref) {
  return MessageController(ref);
});

class MessageController {
  final ProviderRef ref;

  MessageController(this.ref);
  //init Firebase
  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseStorage = FirebaseStorage.instance;

  List<QueryDocumentSnapshot> listMessages = [];

  final TextEditingController messageController = TextEditingController();

  var groupChatId = StateProvider.autoDispose<String>(((ref) => ''));
  // var currentUserId = StateProvider.autoDispose<String>(((ref) => ''));
  var currentUserId = '';
  var isMessagesLoaded = false;
  bool isMessageReceived(int index) {
    if ((index > 0 &&
            listMessages[index - 1].get(FirestoreConstants.idFrom) ==
                currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  // checking if sent message
  bool isMessageSent(int index) {
    if ((index > 0 &&
            listMessages[index - 1].get(FirestoreConstants.idFrom) !=
                currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  UploadTask uploadImageFile(File image, String filename) {
    Reference reference = firebaseStorage.ref().child(filename);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }

  Future<void> updateFirestoreData(
      String collectionPath, String docPath, Map<String, dynamic> dataUpdate) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(docPath)
        .update(dataUpdate);
  }

  Stream<QuerySnapshot> getChatMessage(String groupChatId, int limit) {
    isMessagesLoaded = true;
    print('aaaaa');
    return firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy(FirestoreConstants.timestamp, descending: true)
        .limit(limit)
        .snapshots();
  }

  void sendChatMessage(String content, int type, String groupChatId,
      String currentUserId, String peerId) {
    messageController.clear();
    DocumentReference documentReference = firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());
    ChatMessages chatMessages = ChatMessages(
        idFrom: currentUserId,
        idTo: peerId,
        timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content,
        type: type);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(documentReference, chatMessages.toJson());
    });
  }

  readLocal(BuildContext context, String peerId) async {
    if (!isMessagesLoaded) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      currentUserId = sharedPreferences.getString(FirestoreConstants.id) ?? '';
      if (currentUserId != '') {
        if (currentUserId.compareTo(peerId) > 0) {
          ref.read(groupChatId.state).state = '$currentUserId - $peerId';
        } else {
          ref.read(groupChatId.state).state = '$peerId - $currentUserId';
        }
        updateFirestoreData(FirestoreConstants.pathUserCollection,
            currentUserId, {FirestoreConstants.chattingWith: peerId});
      }
    } else {
      print('bbbbbbb');
    }
  }
}
