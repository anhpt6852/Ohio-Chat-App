import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_chat_app/core/config/theme.dart';
import 'package:ohio_chat_app/core/services/fcm_helper.dart';
import 'package:ohio_chat_app/routes.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:timeago/timeago.dart' as timeago;

Future<String?> get firebaseToken {
  return FirebaseMessaging.instance.getToken();
}

Future _displayNotification(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  AppleNotification? ios = message.notification?.apple;

  if (notification != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: android != null
            ? AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: android.smallIcon,
                fullScreenIntent: true,
                importance: Importance.max,
                showWhen: false,
              )
            : null,
        iOS: ios != null
            ? const IOSNotificationDetails(
                presentAlert: true,
                presentSound: true,
              )
            : null,
      ),
      payload: jsonEncode(message.data),
    );
    return null;
  }
}

_messageHandler(RemoteMessage message) async {
  await _displayNotification(message);
  return null;
}

Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  return;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

  timeago.setLocaleMessages('vi', timeago.ViMessages());
  timeago.setLocaleMessages('en', timeago.EnMessages());

  FirebaseMessaging.instance.requestPermission();
  FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  FirebaseMessaging.onMessage.listen(_messageHandler);
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: false,
    sound: false,
    badge: false,
  );

  var deviceToken = await FirebaseMessaging.instance.getToken();

  print('deviceToken: ' + deviceToken!);

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    var token = await firebaseToken;
    print('A new onMessageOpenedApp event was published!');
  });

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
