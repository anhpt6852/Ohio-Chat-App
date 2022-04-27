import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ohio_chat_app/core/constant/colors.dart';
import 'package:ohio_chat_app/generated/assets.gen.dart';
import 'package:ohio_chat_app/generated/locale_keys.g.dart';

class LanguageSelector {
  static void showCustomDialog(BuildContext context,
      {required String language}) {
    var listLanguage = ['vi', 'en'];
    Widget getFlag(String lang) {
      Widget flagWidget;
      switch (lang) {
        case 'vi':
          flagWidget = Assets.images.vnFlag.image();
          break;
        case 'en':
          flagWidget = Assets.images.ukFlag.image();
          break;
        default:
          flagWidget = Assets.images.vnFlag.image();
      }
      return flagWidget;
    }

    getString(String lang) {
      Widget textWidget;
      switch (lang) {
        case 'vi':
          textWidget = Text(tr(LocaleKeys.login_language_selector_vietnam));
          break;
        case 'en':
          textWidget = Text(tr(LocaleKeys.login_language_selector_england));
          break;
        default:
          textWidget = Text(tr(LocaleKeys.login_language_selector_vietnam));
      }
      return textWidget;
    }

    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: listLanguage
                  .map((e) => GestureDetector(
                        onTap: () {
                          language = e;
                        },
                        child: Material(
                          color: Colors.transparent,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: e == language
                                        ? Border.all(
                                            width: 2.0,
                                            color: AppColors.primary)
                                        : null,
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const SizedBox(width: 8),
                                        SizedBox(
                                            height: 24,
                                            width: 32,
                                            child: getFlag(e)),
                                        const SizedBox(width: 8),
                                        getString(e),
                                      ],
                                    ),
                                    Checkbox(
                                        value: e == language,
                                        onChanged: (value) {}),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8.0)
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }
}
