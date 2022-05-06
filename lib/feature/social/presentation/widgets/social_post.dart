import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_chat_app/core/commons/presentation/snack_bar.dart';
import 'package:ohio_chat_app/core/config/theme.dart';
import 'package:ohio_chat_app/core/constant/colors.dart';
import 'package:ohio_chat_app/feature/chat/data/models/chat_user.dart';
import 'package:ohio_chat_app/feature/social/data/models/newfeeds.dart';
import 'package:ohio_chat_app/feature/social/presentation/controller/social_controller.dart';
import 'package:ohio_chat_app/feature/social/presentation/widgets/bottomsheet_post.dart';
import 'package:ohio_chat_app/feature/social/presentation/widgets/comments_page.dart';
import 'package:ohio_chat_app/feature/social/presentation/widgets/common_react.dart';
import 'package:ohio_chat_app/generated/locale_keys.g.dart';

class SocialPost extends ConsumerWidget {
  SocialPost({Key? key, required this.documentSnapshot}) : super(key: key);

  final DocumentSnapshot documentSnapshot;

  final FocusNode focusNode = FocusNode();

  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var controller = ref.watch(socialControllerProvider);
    Newfeeds newfeeds = Newfeeds.fromDocument(documentSnapshot);

    buildComment(ChatUser user) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            user.photoUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      user.photoUrl,
                      fit: BoxFit.cover,
                      width: 32,
                      height: 32,
                      loadingBuilder: (BuildContext ctx, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return const SizedBox(
                              width: 32,
                              height: 32,
                              child: CircularProgressIndicator());
                        }
                      },
                      errorBuilder: (context, object, stackTrace) {
                        return const Icon(Icons.account_circle, size: 24);
                      },
                    ),
                  )
                : Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: AppColors.ink[400]),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
            const SizedBox(width: 8),
            Flexible(
                child: SizedBox(
              height: 40,
              child: TextField(
                focusNode: focusNode,
                controller: commentController,
                cursorColor: AppColors.primary,
                style: t14R,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: 'Viết bình luận...',
                  hintStyle: t14R,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                ),
              ),
            )),
            focusNode.hasFocus
                ? const SizedBox(width: 8)
                : const SizedBox.shrink(),
            focusNode.hasFocus
                ? GestureDetector(
                    onTap: () {
                      controller.commentPost(commentController.text,
                          documentSnapshot.id, newfeeds.comments);
                      commentController.clear();
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
      );
    }

    return StreamBuilder(
        stream: controller.getDataUser(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            var user = ChatUser.fromDocument(snapshot.data!.docs
                .firstWhere((element) => element.id == newfeeds.id));
            return Container(
              color: AppColors.ink[0],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 16.0, right: 16.0, left: 16.0, bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            user.photoUrl.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      user.photoUrl,
                                      fit: BoxFit.cover,
                                      width: 48,
                                      height: 48,
                                      loadingBuilder: (BuildContext ctx,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return const SizedBox(
                                              width: 48,
                                              height: 48,
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                      },
                                      errorBuilder:
                                          (context, object, stackTrace) {
                                        return const Icon(Icons.account_circle,
                                            size: 40);
                                      },
                                    ),
                                  )
                                : Container(
                                    height: 48,
                                    width: 48,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.ink[400]),
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: Text(
                                    user.displayName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: t20M.copyWith(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                    DateFormat('dd MMM yyyy, hh:mm a').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(newfeeds.timestamp),
                                      ),
                                    ),
                                    style: t12M.copyWith(
                                        color: AppColors.ink[400])),
                              ],
                            ),
                          ],
                        ),
                        controller.displayUserId() == newfeeds.id
                            ? GestureDetector(
                                onTap: (() =>
                                    BottomSheetPost.show(context, () async {
                                      var deleteRes = await controller
                                          .deletePost(documentSnapshot.id);
                                      Navigator.of(context).pop();
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
                                    }, tr(LocaleKeys.social_delete_post))),
                                child: const Icon(Icons.more_horiz))
                            : const SizedBox.shrink()
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
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
                              padding: const EdgeInsets.only(
                                  top: 0.0,
                                  right: 16.0,
                                  left: 16.0,
                                  bottom: 0.0),
                              child: Text(
                                newfeeds.content,
                                style: t16R,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Image.network(
                              newfeeds.image,
                              height: 240,
                              width: double.infinity,
                            )
                          ],
                        ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 0.0, right: 8.0, left: 8.0, bottom: 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${newfeeds.react.length} ${tr(LocaleKeys.social_like_count)}',
                          style: t14M.copyWith(color: AppColors.ink[400]),
                        ),
                        Text(
                            '${newfeeds.comments.length} ${tr(LocaleKeys.social_comment_count)}',
                            style: t14M.copyWith(color: AppColors.ink[400])),
                      ],
                    ),
                  ),
                  Divider(
                    color: AppColors.ink[400],
                  ),
                  CommonReact(
                      newfeeds: newfeeds,
                      onTapComment: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CommentPage(
                                  userPostAvatar: user.photoUrl,
                                  userPostName: user.displayName,
                                  postId: documentSnapshot.id,
                                )));
                      },
                      documentId: documentSnapshot.id),
                  Divider(
                    color: AppColors.ink[400],
                  ),
                  Container(
                      padding: const EdgeInsets.only(
                          top: 0.0, right: 16.0, left: 16.0, bottom: 8.0),
                      child: buildComment(user))
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        });
  }
}
