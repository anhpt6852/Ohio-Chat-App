import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final languageControllerProvider = Provider((ref) {
  return LanguageController(ref);
});

class LanguageController {
  final ProviderRef ref;

  LanguageController(
    this.ref,
  );

  languageSelector(BuildContext context) => StateProvider<Locale>((ref) {
        return EasyLocalization.of(context)!.locale;
      });
}
