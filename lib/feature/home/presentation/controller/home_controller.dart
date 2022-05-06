import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_chat_app/core/constant/firestore_constants.dart';
import 'package:ohio_chat_app/core/services/fcm_helper.dart';
import 'package:ohio_chat_app/feature/chat/data/models/chat_user.dart';
import 'package:ohio_chat_app/feature/chat/data/models/message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

final homeControllerProvider = Provider.autoDispose((ref) {
  return HomeController(ref: ref);
});

class HomeController {
  ProviderRef ref;
  //init Firebase
  final db = FirebaseFirestore.instance;

  HomeController({required this.ref});
  var currentUid = StateProvider.autoDispose<String>(((ref) => ''));
  var currentIndex = StateProvider.autoDispose<int>(((ref) => 0));
  var userChat = StateProvider.autoDispose<ChatUser>(((ref) => const ChatUser(
      id: '', photoUrl: '', displayName: '', phoneNumber: '', aboutMe: '')));

  getCurrentUid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ref.read(currentUid.state).state =
        prefs.getString(FirestoreConstants.id) ?? '';
  }

  String? getUserAvatar() {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    return firebaseAuth.currentUser!.photoURL ?? '';
  }

  Future<void> updateFirestoreData(
      String collectionPath, String path, Map<String, dynamic> updateData) {
    return db.collection(collectionPath).doc(path).update(updateData);
  }

  updateFirestoreMessages(String groupChatId, String path) {
    db
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(path)
        .update({'isSeen': true});
  }

  // pushNotiLocal(String groupChatId, String title) async {
  //   var mess = <ChatMessages>[];
  //   await db
  //       .collection(FirestoreConstants.pathMessageCollection)
  //       .doc(groupChatId)
  //       .collection(groupChatId)
  //       .orderBy(FirestoreConstants.timestamp, descending: true)
  //       .snapshots()
  //       .forEach((event) async {
  //     event.docs.forEach((element) {
  //       mess.add(ChatMessages.fromDocument(element));
  //     });
  //     if (event.docs.isNotEmpty) {
  //       List userNotificated = event.docs.first.get('userNotificated');

  //       if (!mess.first.isSeen &&
  //           mess.first.idTo == ref.read(currentUid.state).state) {
  //         String displayName = '';
  //         if (!userNotificated
  //             .contains(await FirebaseMessaging.instance.getToken())) {
  //           userNotificated.add(await FirebaseMessaging.instance.getToken());

  //           await db
  //               .collection(FirestoreConstants.pathUserCollection)
  //               .snapshots()
  //               .forEach((user) {
  //             user.docs.forEach((userSend) {
  //               if (userSend.id == mess.first.idTo) {
  //                 displayName = userSend.get('displayName');
  //                 flutterLocalNotificationsPlugin.zonedSchedule(
  //                     Random().nextInt(99999999),
  //                     displayName,
  //                     mess.first.content,
  //                     tz.TZDateTime.now(tz.local)
  //                         .add(const Duration(milliseconds: 100)),
  //                     NotificationDetails(
  //                         android: AndroidNotificationDetails(
  //                       channel.id,
  //                       channel.name,
  //                       channelDescription: channel.description,
  //                       fullScreenIntent: true,
  //                       importance: Importance.max,
  //                       showWhen: false,
  //                     )),
  //                     uiLocalNotificationDateInterpretation:
  //                         UILocalNotificationDateInterpretation.absoluteTime,
  //                     androidAllowWhileIdle: true);
  //               }
  //             });
  //           });
  //           await db
  //               .collection(FirestoreConstants.pathMessageCollection)
  //               .doc(groupChatId)
  //               .collection(groupChatId)
  //               .doc(event.docs.first.id)
  //               .update({'userNotificated': userNotificated});
  //         }
  //       } else {
  //         print('Not id : ${ref.read(currentUid.state).state}');
  //       }
  //     }
  //   });
  // }

  Stream<QuerySnapshot> getChatMessage(String groupChatId, int limit) {
    print('aaaaa');
    // pushNotiLocal(groupChatId, '');

    return db
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy(FirestoreConstants.timestamp, descending: true)
        .limit(limit)
        .snapshots();
  }

  Stream<QuerySnapshot> getFirestoreData(String collectionPath, int limit) {
    var data = db.collection(collectionPath).limit(limit).snapshots();
    return db.collection(collectionPath).limit(limit).snapshots();
  }
}
