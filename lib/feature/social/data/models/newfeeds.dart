import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ohio_chat_app/core/constant/firestore_constants.dart';

class Newfeeds {
  String id;
  String timestamp;
  String content;
  String image;
  List comments;
  List react;
  List color;

  Newfeeds({
    required this.id,
    required this.timestamp,
    required this.comments,
    required this.react,
    required this.content,
    required this.image,
    required this.color,
  });

  Map<String, dynamic> toJson() {
    return {
      FirestoreConstants.id: id,
      FirestoreConstants.timestamp: timestamp,
      FirestoreConstants.content: content,
      FirestoreConstants.image: image,
      FirestoreConstants.comments: comments,
      FirestoreConstants.react: react,
      'color': color
    };
  }

  factory Newfeeds.fromDocument(DocumentSnapshot documentSnapshot) {
    String id = documentSnapshot.get(FirestoreConstants.id);
    String timestamp = documentSnapshot.get(FirestoreConstants.timestamp);
    List comments = documentSnapshot.get(FirestoreConstants.comments);
    List react = documentSnapshot.get(FirestoreConstants.react);
    String content = documentSnapshot.get(FirestoreConstants.content);
    String image = documentSnapshot.get(FirestoreConstants.image);
    List color = documentSnapshot.get('color');

    return Newfeeds(
        id: id,
        timestamp: timestamp,
        content: content,
        image: image,
        comments: comments,
        react: react,
        color: color);
  }
}
