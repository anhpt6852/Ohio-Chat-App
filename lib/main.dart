import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_chat_app/core/config/theme.dart';
import 'package:ohio_chat_app/routes.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:timeago/timeago.dart' as timeago;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  timeago.setLocaleMessages('vi', timeago.ViMessages());
  timeago.setLocaleMessages('en', timeago.EnMessages());

  runApp(
    EasyLocalization(
        supportedLocales: const [
          Locale('vi'), // Vietnamese
          Locale('en'), // English
        ],
        useOnlyLangCode: true,
        saveLocale: true,
        path: 'assets/translations',
        fallbackLocale: const Locale('vi'),
        child: const ProviderScope(child: MyApp())),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      theme: appLightTheme,
      onGenerateRoute: (settings) => AppRouter.onGenerateRoute(settings),
      initialRoute: AppRoutes.login,
      locale: context.locale,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      builder: (context, widget) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
        child: ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, widget ?? Container()),
          maxWidth: 1280,
          minWidth: 375,
          defaultScale: true,
          breakpoints: const [
            ResponsiveBreakpoint.autoScale(375, name: MOBILE),
            ResponsiveBreakpoint.resize(450, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: TABLET),
            ResponsiveBreakpoint.resize(1000, name: TABLET),
          ],
        ),
      ),
    );
  }
}
