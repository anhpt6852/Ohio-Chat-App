import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_chat_app/core/commons/presentation/common_loading.dart';
import 'package:ohio_chat_app/core/commons/presentation/snack_bar.dart';
import 'package:ohio_chat_app/core/config/theme.dart';
import 'package:ohio_chat_app/core/constant/colors.dart';
import 'package:ohio_chat_app/feature/register/presentation/controller/register_controller.dart';
import 'package:ohio_chat_app/generated/locale_keys.g.dart';

class ConfirmEmailPage extends ConsumerWidget {
  const ConfirmEmailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final controller = ref.watch(registerControllerProvider);

    final appBar = AppBar(
        title: Text(tr(LocaleKeys.register_verify_title),
            style: t16M.copyWith(color: AppColors.ink[500])),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios)));

    return Scaffold(
      appBar: appBar,
    );
  }
}
