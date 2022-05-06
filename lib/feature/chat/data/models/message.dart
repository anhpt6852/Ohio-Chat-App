import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ohio_chat_app/core/constant/firestore_constants.dart';

class ChatMessages {
  String idFrom;
  String idTo;
  String timestamp;
  String content;
  bool isSeen;
  int type;
  List userNotificated;

  ChatMessages(
      {required this.idFrom,
      required this.idTo,
      required this.timestamp,
      required this.content,
      required this.isSeen,
      required this.userNotificated,
      required this.type});

  Map<String, dynamic> toJson() {
    return {
      FirestoreConstants.idFrom: idFrom,
      FirestoreConstants.idTo: idTo,
      FirestoreConstants.timestamp: timestamp,
      FirestoreConstants.content: content,
      FirestoreConstants.isSeen: isSeen,
      FirestoreConstants.type: type,
      'userNotificated': userNotificated,
    };
  }

  factory ChatMessages.fromDocument(DocumentSnapshot documentSnapshot) {
    String idFrom = documentSnapshot.get(FirestoreConstants.idFrom);
    String idTo = documentSnapshot.get(FirestoreConstants.idTo);
    String timestamp = documentSnapshot.get(FirestoreConstants.timestamp);
    String content = documentSnapshot.get(FirestoreConstants.content);
    bool isSeen = documentSnapshot.get(FirestoreConstants.isSeen) ?? true;
    int type = documentSnapshot.get(FirestoreConstants.type);
    List userNotificated = documentSnapshot.get('userNotificated');

    return ChatMessages(
        idFrom: idFrom,
        idTo: idTo,
        timestamp: timestamp,
        content: content,
        isSeen: isSeen,
        userNotificated: userNotificated,
        type: type);
  }
}
