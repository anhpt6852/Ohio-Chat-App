import 'package:flutter/material.dart';
import 'package:ohio_templates/core/constant/colors.dart';
import 'package:ohio_templates/feature/login/presentation/widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ink[0],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Expanded(child: LoginForm())],
        ),
      ),
    );
  }
}
