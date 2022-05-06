import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_chat_app/core/constant/colors.dart';
import 'package:ohio_chat_app/feature/login/presentation/controller/language_controller.dart';
import 'package:ohio_chat_app/feature/login/presentation/controller/login_controller.dart';
import 'package:ohio_chat_app/feature/login/presentation/widgets/language_selector.dart';
import 'package:ohio_chat_app/generated/assets.gen.dart';
import 'package:ohio_chat_app/routes.dart';

class LanguageWidget extends ConsumerWidget {
  const LanguageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(languageControllerProvider);

    Widget getFlag(Locale lang) {
      Widget flagWidget;
      switch (lang.languageCode) {
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

    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, right: 16),
        child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.language);
            },
            child: Container(
                height: 24,
                width: 32,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(width: 1.0, color: AppColors.ink[0]!)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child:
                      getFlag(ref.watch(controller.languageSelector(context))),
                ))),
      ),
    );
  }
}
