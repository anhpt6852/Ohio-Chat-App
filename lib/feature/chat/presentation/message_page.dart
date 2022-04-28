import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ohio_chat_app/core/commons/presentation/common_text_form_field.dart';
import 'package:ohio_chat_app/core/config/theme.dart';
import 'package:ohio_chat_app/core/constant/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ohio_chat_app/core/constant/firestore_constants.dart';
import 'package:ohio_chat_app/core/constant/message_constants.dart';
import 'package:ohio_chat_app/feature/chat/data/models/message.dart';
import 'package:ohio_chat_app/feature/chat/presentation/controller/message_controller.dart';
import 'package:ohio_chat_app/feature/login/presentation/login_page.dart';
import 'package:ohio_chat_app/generated/locale_keys.g.dart';

class ChatPage extends ConsumerWidget {
  final String peerId;
  final String peerAvatar;
  final String peerNickname;
  final String userAvatar;

  ChatPage(
      {Key? key,
      required this.peerNickname,
      required this.peerAvatar,
      required this.peerId,
      required this.userAvatar})
      : super(key: key);

  File? imageFile;
  bool isLoading = false;
  bool isShowSticker = false;
  String imageUrl = '';

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context, ref) {
    final controller = ref.watch(messageControllerProvider);

    Widget chatImage({required String imageSrc, required Function onTap}) {
      return GestureDetector(
        onTap: onTap(),
        child: Image.network(
          imageSrc,
          width: 200,
          height: 200,
          fit: BoxFit.contain,
          loadingBuilder: (BuildContext ctx, Widget child,
              ImageChunkEvent? loadingProgress) {
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
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          chatContent,
          style: t16M.copyWith(color: textColor),
        ),
      );
    }

    Widget buildItem(int index, DocumentSnapshot? documentSnapshot) {
      if (documentSnapshot != null) {
        ChatMessages chatMessages = ChatMessages.fromDocument(documentSnapshot);
        if (chatMessages.idFrom == controller.currentUserId) {
          // right side (my message)
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              chatMessages.type == MessageType.text
                  ? messageBubble(
                      chatContent: chatMessages.content,
                      color: AppColors.primary,
                      textColor: AppColors.ink[0],
                      margin: const EdgeInsets.only(right: 8, top: 2),
                    )
                  : chatMessages.type == MessageType.image
                      ? GestureDetector(
                          onTap: () => controller.showPreviewDialog(
                              context, chatMessages.content),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8, top: 8),
                            child: chatImage(
                                imageSrc: chatMessages.content, onTap: () {}),
                          ),
                        )
                      : const SizedBox.shrink(),
              controller.isMessageSent(index)
                  ? Container(
                      margin:
                          const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                      child: Text(
                        DateFormat('dd MMM yyyy, hh:mm a').format(
                          DateTime.fromMillisecondsSinceEpoch(
                            int.parse(chatMessages.timestamp),
                          ),
                        ),
                        style: TextStyle(
                            color: AppColors.ink[500],
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
                  controller.isMessageReceived(index)
                      // left side (received message)
                      ? Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Image.network(
                            peerAvatar,
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
                              return CircleAvatar(
                                radius: 16,
                                backgroundColor: AppColors.ink[400],
                                child: Icon(
                                  Icons.person,
                                  color: AppColors.ink[0],
                                  size: 24,
                                ),
                              );
                            },
                          ),
                        )
                      : Container(
                          width: 32,
                        ),
                  chatMessages.type == MessageType.text
                      ? messageBubble(
                          color: AppColors.primary,
                          textColor: AppColors.ink[0],
                          chatContent: chatMessages.content,
                          margin: const EdgeInsets.only(left: 8, top: 2),
                        )
                      : chatMessages.type == MessageType.image
                          ? GestureDetector(
                              onTap: () => controller.showPreviewDialog(
                                  context, chatMessages.content),
                              child: Container(
                                margin: const EdgeInsets.only(left: 8, top: 8),
                                child: chatImage(
                                    imageSrc: chatMessages.content,
                                    onTap: () {}),
                              ),
                            )
                          : const SizedBox.shrink(),
                ],
              ),
              controller.isMessageReceived(index)
                  ? Container(
                      margin:
                          const EdgeInsets.only(left: 48, top: 8, bottom: 8),
                      child: Text(
                        DateFormat('dd MMM yyyy, hh:mm a').format(
                          DateTime.fromMillisecondsSinceEpoch(
                            int.parse(chatMessages.timestamp),
                          ),
                        ),
                        style: TextStyle(
                            color: AppColors.ink[500],
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

    Widget buildPeerInfo(int index, DocumentSnapshot? documentSnapshot) {
      if (documentSnapshot != null) {
        return Center(
          child: Column(
            children: [
              peerAvatar == ''
                  ? Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.ink[400],
                        child: Icon(
                          Icons.person,
                          color: AppColors.ink[0],
                          size: 56,
                        ),
                      ),
                    )
                  : Image.network(
                      peerAvatar,
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
              Text(
                peerNickname,
                style: t20M,
              ),
              const Text(
                'OhioChat',
                style: t14M,
              ),
              const SizedBox(height: 24)
            ],
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    }

    Widget buildListMessage() {
      return Flexible(
        child: ref.watch(controller.groupChatId.state).state.isNotEmpty
            ? StreamBuilder<QuerySnapshot>(
                stream: controller.getChatMessage(
                    ref.watch(controller.groupChatId), 20),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    controller.listMessages = snapshot.data!.docs;
                    if (controller.listMessages.isNotEmpty) {
                      return ListView.builder(
                          padding: const EdgeInsets.all(10),
                          itemCount: snapshot.data?.docs.length,
                          reverse: true,
                          controller: scrollController,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                index == (controller.listMessages.length - 1)
                                    ? buildPeerInfo(
                                        index, snapshot.data?.docs[index])
                                    : const SizedBox.shrink(),
                                buildItem(index, snapshot.data?.docs[index]),
                              ],
                            );
                          });
                    } else {
                      return Center(
                        child: Column(
                          children: [
                            peerAvatar == ''
                                ? Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundColor: AppColors.ink[400],
                                      child: Icon(
                                        Icons.person,
                                        color: AppColors.ink[0],
                                        size: 56,
                                      ),
                                    ),
                                  )
                                : Image.network(
                                    peerAvatar,
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext ctx,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.primary,
                                          value: loadingProgress
                                                          .expectedTotalBytes !=
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
                                    errorBuilder:
                                        (context, object, stackTrace) {
                                      return Icon(
                                        Icons.account_circle,
                                        size: 35,
                                        color: AppColors.ink[100],
                                      );
                                    },
                                  ),
                            Text(
                              peerNickname,
                              style: t20M,
                            ),
                            const Text(
                              'OhioChat',
                              style: t14M,
                            ),
                            const SizedBox(height: 24)
                          ],
                        ),
                      );
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })
            : const Center(
                child: CircularProgressIndicator(),
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
                  controller: controller.messageController,
                  height: 52,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: GestureDetector(
                      onTap: () => controller.getImage(
                          ref.read(controller.groupChatId.state).state,
                          controller.currentUserId,
                          peerId),
                      child: Icon(
                        Icons.camera_alt,
                        color: AppColors.ink[400],
                      ),
                    ),
                  ),
                  prefixBoxConstrains:
                      const BoxConstraints(maxHeight: 16, maxWidth: 32),
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => controller.sendChatMessage(
                    controller.messageController.text,
                    MessageType.text,
                    ref.read(controller.groupChatId.state).state,
                    controller.currentUserId,
                    peerId),
                child: CircleAvatar(
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
                ),
              )
            ],
          ));
    }

    return FutureBuilder(
        future: controller.readLocal(context, peerId),
        builder: (context, snapshot) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                leading: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      controller.isMessagesLoaded = false;
                    },
                    child: const Icon(Icons.arrow_back)),
                centerTitle: true,
                title: Row(
                  children: [
                    peerAvatar == ''
                        ? Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: AppColors.ink[400],
                              child: Icon(
                                Icons.person,
                                color: AppColors.ink[0],
                                size: 24,
                              ),
                            ),
                          )
                        : Image.network(
                            peerAvatar,
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
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          peerNickname.trim(),
                          style: t16M.copyWith(color: AppColors.ink[500]),
                        ),
                        controller.getTimeOfLastSeen() == ''
                            ? const SizedBox.shrink()
                            : Text(
                                tr(LocaleKeys.chat_last_seen) +
                                    ' ' +
                                    controller.getTimeOfLastSeen(),
                                style:
                                    t12M.copyWith(color: AppColors.ink[400])),
                      ],
                    ),
                  ],
                ),
              ),
              body: SafeArea(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      buildListMessage(),
                      buildMessageInput(),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
