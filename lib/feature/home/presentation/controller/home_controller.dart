import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_chat_app/core/constant/firestore_constants.dart';
import 'package:ohio_chat_app/core/services/shared_preferences.dart';
import 'package:ohio_chat_app/feature/chat/data/models/chat_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

final homeControllerProvider = Provider.autoDispose((ref) {
  return HomeController(ref: ref);
});

class HomeController {
  ProviderRef ref;
  //init Firebase
  final db = FirebaseFirestore.instance;

  HomeController({required this.ref});
  var currentUid = StateProvider.autoDispose<String>(((ref) => ''));
  var userChat = StateProvider.autoDispose<ChatUser>(((ref) => const ChatUser(
      id: '', photoUrl: '', displayName: '', phoneNumber: '', aboutMe: '')));

  getCurrentUid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ref.read(currentUid.state).state =
        prefs.getString(FirestoreConstants.id) ?? '';
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

  Stream<QuerySnapshot> getChatMessage(String groupChatId, int limit) {
    print('aaaaa');
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
