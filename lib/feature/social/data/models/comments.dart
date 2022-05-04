import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ohio_chat_app/core/constant/firestore_constants.dart';

class Comments {
  String id;
  String timestamp;
  String content;
  String image;

  Comments({
    required this.id,
    required this.timestamp,
    required this.content,
    required this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      FirestoreConstants.id: id,
      FirestoreConstants.timestamp: timestamp,
      FirestoreConstants.content: content,
      FirestoreConstants.image: image,
    };
  }

  factory Comments.fromDocument(DocumentSnapshot documentSnapshot) {
    String id = documentSnapshot.get(FirestoreConstants.id);
    String timestamp = documentSnapshot.get(FirestoreConstants.timestamp);
    String content = documentSnapshot.get(FirestoreConstants.content);
    String image = documentSnapshot.get(FirestoreConstants.image);

    return Comments(
      id: id,
      timestamp: timestamp,
      content: content,
      image: image,
    );
  }
}
