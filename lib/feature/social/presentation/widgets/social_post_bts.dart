import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_chat_app/core/commons/presentation/common_loading.dart';
import 'package:ohio_chat_app/core/commons/presentation/common_text_form_field.dart';
import 'package:ohio_chat_app/core/config/theme.dart';
import 'package:ohio_chat_app/core/constant/colors.dart';
import 'package:ohio_chat_app/generated/locale_keys.g.dart';

class SocialPostBottomSheet {
  static void show(context,
      {required TextEditingController controller,
      required StateProvider<String> imageUrl,
      required StateProvider<bool> isUploadImg,
      required VoidCallback onTap,
      required VoidCallback onTapImage}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height - 32,
          child: SafeArea(
            child: Scaffold(
                backgroundColor: AppColors.ink[0],
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  elevation: 0.0,
                  leading: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.close),
                  ),
                  title: Text(tr(LocaleKeys.social_create_post),
                      style: t16M.copyWith(color: AppColors.ink[500])),
                  centerTitle: true,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          color: AppColors.primary,
                          child: Text(
                            tr(LocaleKeys.social_post_button),
                            style: t14M,
                          ),
                          onPressed: onTap),
                    )
                  ],
                ),
                body: Consumer(builder: (context, ref, child) {
                  return ref.watch(isUploadImg)
                      ? const CommonLoading()
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ref.watch(imageUrl) == ''
                                    ? Stack(
                                        children: [
                                          CommonTextFormField(
                                            height: 344,
                                            maxLines: 13,
                                            controller: controller,
                                            autofocus: true,
                                            hintText:
                                                tr(LocaleKeys.social_hint_text),
                                          ),
                                          Positioned(
                                              bottom: 16,
                                              right: 16,
                                              child: GestureDetector(
                                                onTap: onTapImage,
                                                child: DottedBorder(
                                                    dashPattern: const [4, 3],
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: const Icon(
                                                        Icons.camera_alt,
                                                        size: 32)),
                                              ))
                                        ],
                                      )
                                    : (Column(
                                        children: [
                                          CommonTextFormField(
                                            maxLines: 1,
                                            controller: controller,
                                            autofocus: true,
                                            hintText:
                                                tr(LocaleKeys.social_hint_text),
                                          ),
                                          const SizedBox(height: 16),
                                          Stack(
                                            children: [
                                              Image.network(
                                                ref.watch(imageUrl),
                                                height: 240,
                                                width: double.infinity,
                                              ),
                                              Positioned(
                                                  top: 0,
                                                  right: 0,
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        ref
                                                            .read(
                                                                imageUrl.state)
                                                            .state = '';
                                                      },
                                                      child: const Icon(
                                                          Icons.close)))
                                            ],
                                          ),
                                        ],
                                      )),
                              ),
                            ],
                          ),
                        );
                })),
          ),
        );
      },
    );
  }
}
