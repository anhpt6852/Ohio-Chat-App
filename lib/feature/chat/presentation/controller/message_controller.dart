import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ohio_chat_app/core/constant/colors.dart';
import 'package:ohio_chat_app/core/constant/firestore_constants.dart';
import 'package:ohio_chat_app/core/constant/message_constants.dart';
import 'package:ohio_chat_app/feature/chat/data/models/message.dart';
import 'package:ohio_chat_app/generated/locale_keys.g.dart';
import 'package:shared_preferences/shared_preferences.dart';

final messageControllerProvider = Provider.autoDispose((ref) {
  return MessageController(ref);
});

final getTimeProvider = Provider.autoDispose((ref) {
  return MessageController(ref);
});

class MessageController {
  final ProviderRef ref;

  MessageController(this.ref);
  //init Firebase
  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseStorage = FirebaseStorage.instance;

  List<QueryDocumentSnapshot> listMessages = [];

  File imageFile = File('');

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

  getTimeOfLastSeen() {
    var listTime = [];

    listMessages.forEach((element) {
      if (element.get('isSeen') == true &&
          element.get('idFrom') != currentUserId) {
        listTime.add(element.id);
      }
    });
    if (listTime.isNotEmpty) {
      var timeDiffrence = DateTime.now()
          .difference(DateTime.fromMillisecondsSinceEpoch(
            int.parse(listTime.first),
          ))
          .inHours;
      print(timeDiffrence);
      if (timeDiffrence > 24) {
        return DateTime.now()
                .difference(DateTime.fromMillisecondsSinceEpoch(
                  int.parse(listTime.first),
                ))
                .inDays
                .toString() +
            ' ' +
            tr(LocaleKeys.chat_bf_day);
      }
      if (timeDiffrence < 1) {
        return DateTime.now()
                .difference(DateTime.fromMillisecondsSinceEpoch(
                  int.parse(listTime.first),
                ))
                .inMinutes
                .toString() +
            ' ' +
            tr(LocaleKeys.chat_bf_minute);
      } else {
        return timeDiffrence.toString() + ' ' + tr(LocaleKeys.chat_bf_hour);
      }
    } else {
      return '';
    }
  }

  Future getImage(
      String groupChatId, String currentUserId, String peerId) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile;
    pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      TaskSnapshot snapshot = await uploadImageFile(
          imageFile, DateTime.now().millisecondsSinceEpoch.toString());
      var imageUrl = await snapshot.ref.getDownloadURL();
      sendChatMessage(
          imageUrl, MessageType.image, groupChatId, currentUserId, peerId);
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

  void showPreviewDialog(context, url) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black,
      pageBuilder: (_, __, ___) {
        return SafeArea(
            child: Dismissible(
          direction: DismissDirection.vertical,
          key: const Key('key'),
          onDismissed: (_) => Navigator.of(context).pop(),
          resizeDuration: const Duration(milliseconds: 5),
          child: Stack(
            children: [
              Center(
                  child: Container(
                      color: Colors.transparent, child: Image.network(url))),
              Positioned(
                top: 16,
                left: 16,
                child: GestureDetector(
                  onTap: (() => Navigator.of(context).pop()),
                  child: Icon(
                    Icons.close,
                    size: 32,
                    color: AppColors.ink[0],
                  ),
                ),
              )
            ],
          ),
        ));
      },
      transitionBuilder: (_, anim, __, child) {
        return FadeTransition(
          opacity: anim,
          child: child,
        );
      },
    );
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
        isSeen: false,
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
