import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_chat_app/core/config/theme.dart';
import 'package:ohio_chat_app/core/constant/colors.dart';
import 'package:ohio_chat_app/feature/login/presentation/controller/language_controller.dart';
import 'package:ohio_chat_app/feature/login/presentation/controller/login_controller.dart';
import 'package:ohio_chat_app/generated/assets.gen.dart';
import 'package:ohio_chat_app/generated/locale_keys.g.dart';
import 'package:ohio_chat_app/routes.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var controller = ref.watch(languageControllerProvider);

    final appBar = AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios)));

    buildChooseLanguage(String language) {
      Widget image;
      String country;
      switch (language) {
        case 'vi':
          image = Assets.images.vnFlag.image(height: 24, width: 32);
          country = tr(LocaleKeys.login_language_selector_vietnam);
          break;
        case 'en':
          image = Assets.images.ukFlag.image(height: 24, width: 32);
          country = tr(LocaleKeys.login_language_selector_england);
          break;
        default:
          image = Assets.images.vnFlag.image(height: 24, width: 32);
          country = tr(LocaleKeys.login_language_selector_vietnam);
      }
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: GestureDetector(
          onTap: () {
            ref.read(controller.languageSelector(context).state).state =
                Locale(language);
            EasyLocalization.of(context)!.setLocale(Locale(language));
            Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.login, (route) => false);
          },
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.ink[300]!),
                borderRadius: BorderRadius.circular(16.0)),
            child: ListTile(
              leading: image,
              title: Text(country),
              trailing: Checkbox(
                  value: ref.watch(controller.languageSelector(context)) ==
                      Locale(language),
                  onChanged: (value) {
                    ref.read(controller.languageSelector(context).state).state =
                        Locale(language);
                    EasyLocalization.of(context)!.setLocale(Locale(language));
                    Navigator.pushNamedAndRemoveUntil(
                        context, AppRoutes.login, (route) => false);
                  }),
            ),
          ),
        ),
      );
    }

    final body = SingleChildScrollView(
        child: Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tr(LocaleKeys.chooseLanguage),
              style: t30M.copyWith(color: AppColors.ink[500])),
          const SizedBox(height: 24),
          Column(
            children: List.generate(
                2, (index) => buildChooseLanguage(['vi', 'en'][index])),
          )
        ],
      ),
    ));
    return Scaffold(
      backgroundColor: AppColors.ink[0],
      appBar: appBar,
      body: body,
    );
  }
}
