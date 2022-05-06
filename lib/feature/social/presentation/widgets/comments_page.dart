import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_chat_app/core/commons/presentation/snack_bar.dart';
import 'package:ohio_chat_app/core/config/theme.dart';
import 'package:ohio_chat_app/core/constant/colors.dart';
import 'package:ohio_chat_app/feature/chat/data/models/chat_user.dart';
import 'package:ohio_chat_app/feature/social/data/models/comments.dart';
import 'package:ohio_chat_app/feature/social/data/models/newfeeds.dart';
import 'package:ohio_chat_app/feature/social/presentation/controller/social_controller.dart';
import 'package:ohio_chat_app/feature/social/presentation/widgets/bottomsheet_post.dart';
import 'package:ohio_chat_app/feature/social/presentation/widgets/common_react.dart';
import 'package:ohio_chat_app/generated/locale_keys.g.dart';
import 'package:ohio_chat_app/routes.dart';

class CommentPage extends ConsumerWidget {
  final String userPostAvatar;
  final String userPostName;
  final String postId;

  CommentPage({
    Key? key,
    required this.userPostAvatar,
    required this.userPostName,
    required this.postId,
  }) : super(key: key);

  final FocusNode focusNode = FocusNode();
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var controller = ref.watch(socialControllerProvider);

    final buildListComments = StreamBuilder(
        stream: controller.getComments(postId),
        builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            var comments = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                children: List.generate(comments.length, (index) {
                  var comment = Comments.fromDocument(comments[index]);
                  return Column(
                    children: [
                      const SizedBox(height: 8),
                      StreamBuilder(
                          stream: controller.getUser(comment.id),
                          builder: (context,
                              AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                            if (userSnapshot.hasData) {
                              var userComment =
                                  ChatUser.fromDocument(userSnapshot.data!);
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      userComment.photoUrl == ''
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              child: CircleAvatar(
                                                radius: 18,
                                                backgroundColor:
                                                    AppColors.ink[400],
                                                child: Icon(
                                                  Icons.person,
                                                  color: AppColors.ink[0],
                                                  size: 24,
                                                ),
                                              ),
                                            )
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Image.network(
                                                userComment.photoUrl,
                                                width: 40,
                                                height: 40,
                                                fit: BoxFit.cover,
                                                loadingBuilder:
                                                    (BuildContext ctx,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(
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
                                                errorBuilder: (context, object,
                                                    stackTrace) {
                                                  return Icon(
                                                    Icons.account_circle,
                                                    size: 35,
                                                    color: AppColors.ink[100],
                                                  );
                                                },
                                              ),
                                            ),
                                      const SizedBox(width: 16.0),
                                      GestureDetector(
                                        onLongPress: () {
                                          BottomSheetPost.show(context,
                                              () async {
                                            var deleteRes =
                                                await controller.deleteComments(
                                                    postId,
                                                    comments[index].id,
                                                    comments
                                                        .map((e) => e.id)
                                                        .toList());
                                            Navigator.of(context).pop();
                                            if (deleteRes) {
                                              CommonSnackbar.show(context,
                                                  type: SnackbarType.success,
                                                  message: tr(LocaleKeys
                                                      .social_notification_comment_success));
                                            } else {
                                              CommonSnackbar.show(context,
                                                  type: SnackbarType.error,
                                                  message: tr(LocaleKeys
                                                      .social_notification_comment_failed));
                                            }
                                          },
                                              tr(LocaleKeys
                                                  .social_delete_comment));
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              left: 8.0,
                                              right: 8.0,
                                              bottom: 8.0,
                                              top: 4.0),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                              color: AppColors.ink[200]),
                                          child: ConstrainedBox(
                                            constraints: const BoxConstraints(
                                                maxWidth: 288),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  userComment.displayName,
                                                  style: t16M,
                                                ),
                                                Text(
                                                  comment.content,
                                                  style: t16R,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  comment.image == ''
                                      ? const SizedBox.shrink()
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(left: 56.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                            child: Image.network(
                                              comment.image,
                                              height: 96,
                                            ),
                                          ),
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 56.0),
                                    child: Text(
                                      controller
                                          .getTimeOfLastSeen(comment.timestamp),
                                      style: t12R.copyWith(
                                          color: AppColors.ink[400]),
                                    ),
                                  )
                                ],
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          }),
                    ],
                  );
                }),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        }));

    body(Newfeeds newfeeds, DocumentSnapshot snapshot) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              newfeeds.image == ''
                  ? Container(
                      height: 240,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          gradient: controller.colorPost(newfeeds.color)),
                      child: Center(
                        child: Text(
                          newfeeds.content,
                          style: t20R.copyWith(color: AppColors.ink[0]),
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            newfeeds.content,
                            style: t16R,
                          ),
                        ),
                        Image.network(
                          newfeeds.image,
                          height: 240,
                          width: double.infinity,
                        )
                      ],
                    ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '${newfeeds.react.length} ${tr(LocaleKeys.social_like_count)}',
                  style: t14M.copyWith(color: AppColors.ink[400]),
                ),
              ),
              Divider(
                color: AppColors.ink[400],
              ),
              CommonReact(
                  newfeeds: newfeeds,
                  onTapComment: () {
                    focusNode.requestFocus();
                  },
                  documentId: snapshot.id),
              Divider(
                color: AppColors.ink[400],
              ),
              buildListComments,
              const SizedBox(height: 80),
            ],
          ),
        );

    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: StreamBuilder(
            stream: controller.getNewfeedsDetail(postId),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                var newfeeds = Newfeeds.fromDocument(snapshot.data!);

                return Stack(
                  children: [
                    Scaffold(
                      backgroundColor: AppColors.ink[0],
                      appBar: AppBar(
                        automaticallyImplyLeading: false,
                        elevation: 0.0,
                        leading: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Icon(Icons.arrow_back)),
                        centerTitle: true,
                        title: Row(
                          children: [
                            userPostAvatar == ''
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
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      userPostAvatar,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext ctx,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
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
                                  ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userPostName.trim(),
                                  style:
                                      t16M.copyWith(color: AppColors.ink[500]),
                                ),
                              ],
                            ),
                          ],
                        ),
                        actions: [
                          GestureDetector(
                            onTap: () =>
                                BottomSheetPost.show(context, () async {
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                              var deleteRes =
                                  await controller.deletePost(postId);

                              if (deleteRes) {
                                CommonSnackbar.show(context,
                                    type: SnackbarType.success,
                                    message: tr(LocaleKeys
                                        .social_notification_post_success));
                              } else {
                                CommonSnackbar.show(context,
                                    type: SnackbarType.error,
                                    message: tr(LocaleKeys
                                        .social_notification_post_failed));
                              }
                            }, tr(LocaleKeys.social_delete_post)),
                            child: const Padding(
                              padding: EdgeInsets.only(right: 16.0),
                              child: Icon(Icons.more_horiz),
                            ),
                          )
                        ],
                      ),
                      body: body(newfeeds, snapshot.data!),
                    ),
                    Positioned(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      left: 0,
                      right: 0,
                      child: Material(
                        child: Container(
                          color: AppColors.ink[0],
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        controller.getImage(
                                            controller.imageCommentsUrl);
                                      },
                                      child: const Icon(Icons.camera_alt)),
                                  const SizedBox(width: 8),
                                  Flexible(
                                      child: SizedBox(
                                    height: 40,
                                    child: TextField(
                                      focusNode: focusNode,
                                      controller: commentController,
                                      cursorColor: AppColors.primary,
                                      style: t14R,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      decoration: InputDecoration(
                                        hintText: 'Viết bình luận...',
                                        hintStyle: t14R,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0)),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                      ),
                                    ),
                                  )),
                                  focusNode.hasFocus
                                      ? const SizedBox(width: 8)
                                      : const SizedBox.shrink(),
                                  focusNode.hasFocus
                                      ? GestureDetector(
                                          onTap: () {
                                            controller.commentPost(
                                                commentController.text,
                                                snapshot.data!.id,
                                                newfeeds.comments);
                                            commentController.clear();
                                            ref
                                                .read(controller
                                                    .imageCommentsUrl.state)
                                                .state = '';
                                            FocusScope.of(context).unfocus();
                                          },
                                          child: Icon(
                                            Icons.send,
                                            color: AppColors.ink[500],
                                            size: 24,
                                          ),
                                        )
                                      : const SizedBox.shrink()
                                ],
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.only(left: 32.0),
                                child: ref.watch(controller.imageCommentsUrl) ==
                                        ''
                                    ? const SizedBox.shrink()
                                    : Stack(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(4.0),
                                            decoration: BoxDecoration(
                                                border: Border.all(),
                                                borderRadius:
                                                    BorderRadius.circular(8.0)),
                                            child: Image.network(
                                              ref.watch(
                                                  controller.imageCommentsUrl),
                                              height: 80,
                                            ),
                                          ),
                                          Positioned(
                                              top: 4,
                                              right: 4,
                                              child: GestureDetector(
                                                  onTap: () {
                                                    ref
                                                        .read(controller
                                                            .imageCommentsUrl
                                                            .state)
                                                        .state = '';
                                                  },
                                                  child: CircleAvatar(
                                                      radius: 12,
                                                      backgroundColor:
                                                          AppColors.ink[400],
                                                      child: Icon(Icons.close,
                                                          size: 16,
                                                          color: AppColors
                                                              .ink[0]))))
                                        ],
                                      ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            }));
  }
}
