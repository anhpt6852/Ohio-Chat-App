import 'package:easy_localization/easy_localization.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_chat_app/core/config/theme.dart';
import 'package:ohio_chat_app/core/constant/colors.dart';
import 'package:ohio_chat_app/feature/login/presentation/controller/login_controller.dart';
import 'package:ohio_chat_app/feature/login/presentation/widgets/language_selector.dart';
import 'package:ohio_chat_app/feature/login/presentation/widgets/language_widget.dart';
import 'package:ohio_chat_app/feature/login/presentation/widgets/login_form.dart';
import 'package:ohio_chat_app/generated/assets.gen.dart';
import 'package:ohio_chat_app/generated/locale_keys.g.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref.watch(loginControllerProvider).checkLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.ink[0],
        body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    // SizedBox(
                    //     width: MediaQuery.of(context).size.width,
                    //     height: MediaQuery.of(context).size.height,
                    //     child: Assets.images.loginBackground.image(fit: BoxFit.fill)),
                    // const LanguageWidget(),
                    SizedBox(height: MediaQuery.of(context).size.height / 6),
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
                Positioned(
                  top: 0,
                  right: 0,
                  child: const LanguageWidget(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
