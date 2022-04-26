import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_chat_app/core/constant/colors.dart';
import 'package:ohio_chat_app/feature/login/presentation/controller/login_controller.dart';
import 'package:ohio_chat_app/feature/login/presentation/widgets/language_selector.dart';
import 'package:ohio_chat_app/generated/assets.gen.dart';

class LanguageWidget extends ConsumerWidget {
  const LanguageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(loginControllerProvider);

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

    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, right: 16),
        child: GestureDetector(
            onTap: () => LanguageSelector.showCustomDialog(context,
                language: ref.watch(controller.languageSelector.state).state),
            child: Container(
                height: 24,
                decoration: BoxDecoration(
                    border: Border.all(width: 2.0, color: AppColors.ink[500]!)),
                child: getFlag(
                    ref.watch(controller.languageSelector.state).state))),
      ),
    );
  }
}
