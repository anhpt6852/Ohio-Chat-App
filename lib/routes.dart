import 'package:flutter/material.dart';
import 'package:ohio_chat_app/feature/chat/presentation/message_page.dart';
import 'package:ohio_chat_app/feature/login/presentation/widgets/language_selector.dart';
import 'package:ohio_chat_app/feature/user_profile/presentation/widgets/user_change_password.dart';
import 'package:ohio_chat_app/feature/video_call/presentation/video_call_page.dart';
import 'package:ohio_chat_app/feature/home/presentation/home_page.dart';
import 'package:ohio_chat_app/feature/login/presentation/login_page.dart';
import 'package:ohio_chat_app/feature/register/presentation/register_page.dart';
import 'package:ohio_chat_app/feature/login/presentation/widgets/reset_password_page.dart';
import 'package:ohio_chat_app/feature/user_profile/presentation/user_profile_page.dart';
import 'package:ohio_chat_app/feature/user_profile/presentation/widgets/user_profile_config.dart';

class AppRoutes {
  static const login = '/login-page';
  static const register = '/register-page';
  static const language = '/language-page';
  static const resetPassword = '/reset-password';
  static const changePassword = '/change-password';
  static const home = '/home-page';
  static const chat = '/chat-page';
  static const userProfileConfig = '/user-profile-config';
  static const userProfile = '/user-profile-page';
  static const videoCall = '/video-call-page';
  AppRoutes(Type userProfileConfig);
}

class AppRouter {
  static Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final Animatable<double> _tween = Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.linear));

        return FadeTransition(
          opacity: animation.drive(_tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 500),
    );
  }

  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return _createRoute(const LoginPage());
      case AppRoutes.home:
        return _createRoute(HomePage());
      case AppRoutes.language:
        return _createRoute(const LanguageSelector());
      case AppRoutes.userProfile:
        return _createRoute(const UserProfilePage());
      case AppRoutes.userProfileConfig:
        return _createRoute(const UserProfileConfig());
      case AppRoutes.resetPassword:
        return _createRoute(const ResetPasswordPage());
      case AppRoutes.changePassword:
        return _createRoute(const ChangePasswordPage());
      case AppRoutes.register:
        return _createRoute(RegisterPage());
      case AppRoutes.videoCall:
        return _createRoute(const VideoCallPage());
    }
    return null;
  }
}
