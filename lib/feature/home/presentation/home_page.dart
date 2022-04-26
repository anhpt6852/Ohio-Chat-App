import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_chat_app/core/config/theme.dart';
import 'package:ohio_chat_app/core/constant/colors.dart';
import 'package:ohio_chat_app/core/constant/firestore_constants.dart';
import 'package:ohio_chat_app/feature/chat/data/models/chat_user.dart';
import 'package:ohio_chat_app/feature/chat/presentation/message_page.dart';
import 'package:ohio_chat_app/feature/home/presentation/controller/home_controller.dart';
import 'package:ohio_chat_app/generated/locale_keys.g.dart';

class HomePage extends ConsumerWidget {
  final ScrollController scrollController = ScrollController();

  StreamController<bool> buttonClearController = StreamController<bool>();
  TextEditingController searchTextEditingController = TextEditingController();

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final controller = ref.watch(homeControllerProvider);

    buildItem(BuildContext context, DocumentSnapshot? documentSnapshot) {
      final firebaseAuth = FirebaseAuth.instance;
      controller.getCurrentUid();
      if (documentSnapshot != null) {
        var userChat = ref.watch(controller.userChat.state).state;
        userChat = ChatUser.fromDocument(documentSnapshot);
        if (userChat.id == ref.watch(controller.currentUid.state).state) {
          return const SizedBox.shrink();
        } else {
          return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatPage(
                              peerId: userChat.id,
                              peerAvatar: userChat.photoUrl,
                              peerNickname: userChat.displayName,
                              userAvatar:
                                  firebaseAuth.currentUser!.photoURL ?? '',
                            )));
              },
              child: Column(
                children: [
                  userChat.photoUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.network(
                            userChat.photoUrl,
                            fit: BoxFit.cover,
                            width: 64,
                            height: 64,
                            loadingBuilder: (BuildContext ctx, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return const SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: CircularProgressIndicator(
                                      color: Colors.grey,
                                    ));
                              }
                            },
                            errorBuilder: (context, object, stackTrace) {
                              return const Icon(Icons.account_circle, size: 50);
                            },
                          ),
                        )
                      : Container(
                          height: 64,
                          width: 64,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.ink[400]),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                  Text(
                    userChat.displayName,
                    style: t14M,
                  )
                ],
              ));
        }
      } else {
        return const SizedBox.shrink();
      }
    }

    return Scaffold(
        backgroundColor: AppColors.ink[0],
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircleAvatar(
                backgroundColor: AppColors.ink[400],
                child: Icon(
                  Icons.person,
                  color: AppColors.ink[0],
                  size: 16,
                ),
              ),
            ),
          ),
          title: Text(
            tr(LocaleKeys.home_title),
            style: t16M.copyWith(color: AppColors.ink[500]),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: ref.watch(homeControllerProvider).getFirestoreData(
                    FirestoreConstants.pathUserCollection, 20, ''),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    if ((snapshot.data?.docs.length ?? 0) > 0) {
                      return SizedBox(
                        height: 96,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) =>
                              buildItem(context, snapshot.data?.docs[index]),
                          controller: scrollController,
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text('No user found...'),
                      );
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        ));
  }
}
