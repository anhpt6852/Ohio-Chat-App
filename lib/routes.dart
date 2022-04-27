import 'package:flutter/material.dart';
import 'package:ohio_chat_app/feature/home/presentation/home_page.dart';
import 'package:ohio_chat_app/feature/login/presentation/login_page.dart';
import 'package:ohio_chat_app/feature/register/presentation/register_page.dart';
import 'package:ohio_chat_app/feature/register/presentation/widgets/confirm_email_page.dart';
import 'package:ohio_chat_app/feature/user_profile/presentation/user_profile_page.dart';
import 'package:ohio_chat_app/feature/user_profile/presentation/widgets/user_profile_config.dart';

class AppRoutes {
  static const login = '/login-page';
  static const register = '/register-page';
  static const verify = '/verify-page';
  static const home = '/home-page';
  static const userProfileConfig = '/user-profile-config';
  static const userProfile = '/user-profile-page';
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
        return _createRoute(const HomePage());
      case AppRoutes.userProfile:
        return _createRoute(const UserProfilePage());
      case AppRoutes.verify:
        return _createRoute(const ConfirmEmailPage());
      case AppRoutes.userProfileConfig:
        return _createRoute(UserProfileConfig());
      case AppRoutes.register:
        return _createRoute(RegisterPage());
    }
    return null;
  }
}
