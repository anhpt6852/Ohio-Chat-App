import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_chat_app/core/commons/presentation/common_text_form_field.dart';
import 'package:ohio_chat_app/core/constant/colors.dart';
import 'package:ohio_chat_app/feature/social/presentation/controller/social_controller.dart';
import 'package:ohio_chat_app/feature/social/presentation/widgets/social_post.dart';
import 'package:ohio_chat_app/feature/social/presentation/widgets/social_post_bts.dart';
import 'package:ohio_chat_app/generated/locale_keys.g.dart';

class SocialPage extends ConsumerWidget {
  const SocialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    var controller = ref.watch(socialControllerProvider);
    return SingleChildScrollView(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CommonTextFormField(
            onTap: () {
              ref.read(controller.imageUrl.state).state = '';
              SocialPostBottomSheet.show(
                context,
                controller: controller.postController,
                imageUrl: controller.imageUrl,
                isUploadImg: controller.isUploadImg,
                onTap: () {
                  controller.createNewPost(
                      context, controller.postController.text);
                },
                onTapImage: () {
                  controller.getImage(controller.imageUrl);
                },
              );
            },
            height: 56,
            readOnly: true,
            hintText: tr(LocaleKeys.social_hint_text),
            suffixIcon: const Icon(Icons.edit_note),
            sufflixBoxConstrains:
                const BoxConstraints(maxHeight: 16, maxWidth: 24),
          ),
        ),
        StreamBuilder<QuerySnapshot>(
            stream: controller.getNewfeeds(20),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return Container(
                  color: AppColors.ink[100],
                  child: Column(
                    children: List.generate(
                      snapshot.data!.docs.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SocialPost(
                            documentSnapshot: snapshot.data!.docs[index]),
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
      ],
    ));
  }
}
