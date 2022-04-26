import 'package:easy_localization/easy_localization.dart';
import 'package:flag/flag.dart';
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                // SizedBox(
                //     width: MediaQuery.of(context).size.width,
                //     height: MediaQuery.of(context).size.height,
                //     child: Assets.images.loginBackground.image(fit: BoxFit.fill)),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, right: 16),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                              width: 2.0, color: AppColors.ink[500]!)),
                      child: const Flag.fromString(
                        'us',
                        borderRadius: 6.0,
                        height: 24,
                        width: 32,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Align(
                    alignment: Alignment.center,
                    child: Assets.images.logoBanner.image(
                        width: MediaQuery.of(context).size.width / 1.8,
                        color: AppColors.ink[500]),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      tr(LocaleKeys.login_subtitle),
                      style: t14M.copyWith(color: AppColors.ink[500]),
                    ),
                  ),
                ),
                LoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
