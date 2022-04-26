import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:ohio_chat_app/core/commons/presentation/common_text_form_field.dart';
import 'package:ohio_chat_app/core/config/theme.dart';
import 'package:ohio_chat_app/core/constant/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ohio_chat_app/core/constant/firestore_constants.dart';
import 'package:ohio_chat_app/core/constant/message_constants.dart';
import 'package:ohio_chat_app/feature/chat/data/models/message.dart';
import 'package:ohio_chat_app/feature/login/presentation/login_page.dart';

class ChatPage extends StatefulWidget {
  final String peerId;
  final String peerAvatar;
  final String peerNickname;
  final String userAvatar;

  const ChatPage(
      {Key? key,
      required this.peerNickname,
      required this.peerAvatar,
      required this.peerId,
      required this.userAvatar})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late String currentUserId;

  List<QueryDocumentSnapshot> listMessages = [];

  int _limit = 20;
  final int _limitIncrement = 20;
  String groupChatId = '';

  File? imageFile;
  bool isLoading = false;
  bool isShowSticker = false;
  String imageUrl = '';

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    focusNode.addListener(onFocusChanged);
    scrollController.addListener(_scrollListener);
  }

  _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  void onFocusChanged() {
    if (focusNode.hasFocus) {
      setState(() {
        isShowSticker = false;
      });
    }
  }

  void readLocal() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false);
    if (currentUserId.compareTo(widget.peerId) > 0) {
      groupChatId = '$currentUserId - ${widget.peerId}';
    } else {
      groupChatId = '${widget.peerId} - $currentUserId';
    }
    // chatProvider.updateFirestoreData(FirestoreConstants.pathUserCollection,
    //     currentUserId, {FirestoreConstants.chattingWith: widget.peerId});
  }

  // Future getImage() async {
  //   ImagePicker imagePicker = ImagePicker();
  //   XFile? pickedFile;
  //   pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     imageFile = File(pickedFile.path);
  //     if (imageFile != null) {
  //       setState(() {
  //         isLoading = true;
  //       });
  //       uploadImageFile();
  //     }
  //   }
  // }

  // void uploadImageFile() async {
  //   String fileName = DateTime.now().millisecondsSinceEpoch.toString();
  //   UploadTask uploadTask = chatProvider.uploadImageFile(imageFile!, fileName);
  //   try {
  //     TaskSnapshot snapshot = await uploadTask;
  //     imageUrl = await snapshot.ref.getDownloadURL();
  //     setState(() {
  //       isLoading = false;
  //       onSendMessage(imageUrl, MessageType.image);
  //     });
  //   } on FirebaseException catch (e) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  // void onSendMessage(String content, int type) {
  //   if (content.trim().isNotEmpty) {
  //     textEditingController.clear();
  //     chatProvider.sendChatMessage(
  //         content, type, groupChatId, currentUserId, widget.peerId);
  //     scrollController.animateTo(0,
  //         duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  //   } else {}
  // }

  // checking if received message
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: [
            widget.userAvatar == ''
                ? Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.ink[400],
                      child: Icon(
                        Icons.person,
                        color: AppColors.ink[0],
                        size: 16,
                      ),
                    ),
                  )
                : Image.network(
                    widget.userAvatar,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext ctx, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                          value: loadingProgress.expectedTotalBytes != null &&
                                  loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, object, stackTrace) {
                      return Icon(
                        Icons.account_circle,
                        size: 35,
                        color: AppColors.ink[100],
                      );
                    },
                  ),
            const SizedBox(width: 8),
            Text(
              widget.peerNickname.trim(),
              style: t16M.copyWith(color: AppColors.ink[500]),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                ),
              ),
              // buildListMessage(),
              buildMessageInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMessageInput() {
    return Container(
        color: Colors.transparent,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: CommonTextFormField(
                height: 52,
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.camera_alt,
                    color: AppColors.ink[400],
                  ),
                ),
                prefixBoxConstrains:
                    const BoxConstraints(maxHeight: 16, maxWidth: 32),
              ),
            ),
            const SizedBox(width: 16),
            CircleAvatar(
              radius: 24,
              child: Center(
                child: Transform.rotate(
                  angle: 12,
                  child: Icon(
                    Icons.send,
                    color: AppColors.ink[0],
                    size: 24,
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Widget buildItem(int index, DocumentSnapshot? documentSnapshot) {
    if (documentSnapshot != null) {
      ChatMessages chatMessages = ChatMessages.fromDocument(documentSnapshot);
      if (chatMessages.idFrom == currentUserId) {
        // right side (my message)
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                chatMessages.type == MessageType.text
                    ? messageBubble(
                        chatContent: chatMessages.content,
                        color: AppColors.primary,
                        textColor: AppColors.ink[0],
                        margin: const EdgeInsets.only(right: 8),
                      )
                    : chatMessages.type == MessageType.image
                        ? Container(
                            margin: const EdgeInsets.only(right: 8, top: 8),
                            child: chatImage(
                                imageSrc: chatMessages.content, onTap: () {}),
                          )
                        : const SizedBox.shrink(),
                isMessageSent(index)
                    ? Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: widget.userAvatar == ''
                            ? const SizedBox.shrink()
                            : Image.network(
                                widget.userAvatar,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext ctx, Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.primary,
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                      null &&
                                                  loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, object, stackTrace) {
                                  return Icon(
                                    Icons.account_circle,
                                    size: 35,
                                    color: AppColors.ink[100],
                                  );
                                },
                              ),
                      )
                    : Container(
                        width: 35,
                      ),
              ],
            ),
            isMessageSent(index)
                ? Container(
                    margin: const EdgeInsets.only(right: 48, top: 8, bottom: 8),
                    child: Text(
                      DateFormat('dd MMM yyyy, hh:mm a').format(
                        DateTime.fromMillisecondsSinceEpoch(
                          int.parse(chatMessages.timestamp),
                        ),
                      ),
                      style: TextStyle(
                          color: AppColors.ink[100],
                          fontSize: 8,
                          fontStyle: FontStyle.italic),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                isMessageReceived(index)
                    // left side (received message)
                    ? Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Image.network(
                          widget.peerAvatar,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext ctx, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                                value: loadingProgress.expectedTotalBytes !=
                                            null &&
                                        loadingProgress.expectedTotalBytes !=
                                            null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, object, stackTrace) {
                            return Icon(
                              Icons.account_circle,
                              size: 35,
                              color: AppColors.ink[100],
                            );
                          },
                        ),
                      )
                    : Container(
                        width: 35,
                      ),
                chatMessages.type == MessageType.text
                    ? messageBubble(
                        color: AppColors.primary,
                        textColor: AppColors.ink[0],
                        chatContent: chatMessages.content,
                        margin: const EdgeInsets.only(left: 8),
                      )
                    : chatMessages.type == MessageType.image
                        ? Container(
                            margin: const EdgeInsets.only(left: 8, top: 8),
                            child: chatImage(
                                imageSrc: chatMessages.content, onTap: () {}),
                          )
                        : const SizedBox.shrink(),
              ],
            ),
            isMessageReceived(index)
                ? Container(
                    margin: const EdgeInsets.only(left: 48, top: 8, bottom: 8),
                    child: Text(
                      DateFormat('dd MMM yyyy, hh:mm a').format(
                        DateTime.fromMillisecondsSinceEpoch(
                          int.parse(chatMessages.timestamp),
                        ),
                      ),
                      style: TextStyle(
                          color: AppColors.ink[100],
                          fontSize: 8,
                          fontStyle: FontStyle.italic),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  // Widget buildListMessage() {
  //   return Flexible(
  //     child: groupChatId.isNotEmpty
  //         ? StreamBuilder<QuerySnapshot>(
  //             stream: chatProvider.getChatMessage(groupChatId, _limit),
  //             builder: (BuildContext context,
  //                 AsyncSnapshot<QuerySnapshot> snapshot) {
  //               if (snapshot.hasData) {
  //                 listMessages = snapshot.data!.docs;
  //                 if (listMessages.isNotEmpty) {
  //                   return ListView.builder(
  //                       padding: const EdgeInsets.all(10),
  //                       itemCount: snapshot.data?.docs.length,
  //                       reverse: true,
  //                       controller: scrollController,
  //                       itemBuilder: (context, index) =>
  //                           buildItem(index, snapshot.data?.docs[index]));
  //                 } else {
  //                   return const Center(
  //                     child: Text('No messages...'),
  //                   );
  //                 }
  //               } else {
  //                 return const Center(
  //                   child: CircularProgressIndicator(
  //                     color: AppColors.primary,
  //                   ),
  //                 );
  //               }
  //             })
  //         : const Center(
  //             child: CircularProgressIndicator(
  //               color: AppColors.primary,
  //             ),
  //           ),
  //   );
  // }

  Widget chatImage({required String imageSrc, required Function onTap}) {
    return OutlinedButton(
      onPressed: onTap(),
      child: Image.network(
        imageSrc,
        width: 200,
        height: 200,
        fit: BoxFit.cover,
        loadingBuilder:
            (BuildContext ctx, Widget child, ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            decoration: BoxDecoration(
              color: AppColors.ink[200],
              borderRadius: BorderRadius.circular(8),
            ),
            width: 200,
            height: 200,
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
                value: loadingProgress.expectedTotalBytes != null &&
                        loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, object, stackTrace) => Container(),
      ),
    );
  }

  Widget messageBubble(
      {required String chatContent,
      required EdgeInsetsGeometry? margin,
      Color? color,
      Color? textColor}) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: margin,
      width: 200,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        chatContent,
        style: TextStyle(fontSize: 16, color: textColor),
      ),
    );
  }
}
