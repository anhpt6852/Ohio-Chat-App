import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_chat_app/core/config/theme.dart';
import 'package:ohio_chat_app/core/constant/colors.dart';
import 'package:ohio_chat_app/feature/social/data/models/newfeeds.dart';
import 'package:ohio_chat_app/feature/social/presentation/controller/social_controller.dart';
import 'package:ohio_chat_app/generated/locale_keys.g.dart';

class CommonReact extends ConsumerWidget {
  final Newfeeds newfeeds;
  final String documentId;
  final VoidCallback onTapComment;

  const CommonReact(
      {Key? key,
      required this.newfeeds,
      required this.onTapComment,
      required this.documentId})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var controller = ref.watch(socialControllerProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Flexible(
          child: CupertinoButton(
            minSize: 32,
            padding: EdgeInsets.zero,
            onPressed: () {
              controller.reactPost(documentId, newfeeds.react);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.thumb_up_alt_outlined,
                  size: 20,
                  color: controller.checkReactPost(newfeeds.react)
                      ? AppColors.primary
                      : AppColors.ink[500],
                ),
                const SizedBox(width: 8),
                Text(
                  tr(LocaleKeys.social_like),
                  style: t16R.copyWith(
                    color: controller.checkReactPost(newfeeds.react)
                        ? AppColors.primary
                        : AppColors.ink[500],
                  ),
                ),
              ],
            ),
          ),
        ),
        Flexible(
          child: CupertinoButton(
            minSize: 32,
            padding: EdgeInsets.zero,
            onPressed: onTapComment,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.comment_outlined,
                    size: 20, color: AppColors.ink[500]),
                const SizedBox(width: 8),
                Text(
                  tr(LocaleKeys.social_comment),
                  style: t16R.copyWith(color: AppColors.ink[500]),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
