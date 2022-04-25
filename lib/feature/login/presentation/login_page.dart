import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ohio_chat_app/core/config/theme.dart';
import 'package:ohio_chat_app/core/constant/colors.dart';
import 'package:ohio_chat_app/feature/login/presentation/widgets/login_form.dart';
import 'package:ohio_chat_app/generated/assets.gen.dart';
import 'package:ohio_chat_app/generated/locale_keys.g.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.ink[0],
        body: SafeArea(
          child: Stack(
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Assets.images.loginBackground.image(fit: BoxFit.fill)),
              Positioned(
                top: MediaQuery.of(context).size.height / 5,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Align(
                    alignment: Alignment.center,
                    child: Assets.images.logoBanner.image(
                        width: MediaQuery.of(context).size.width / 1.8,
                        color: AppColors.ink[0]),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 5 + 96,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      tr(LocaleKeys.login_subtitle),
                      style: t16M.copyWith(color: AppColors.ink[0]),
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Expanded(child: LoginForm())],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
