import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ohio_chat_app/core/config/theme.dart';
import 'package:ohio_chat_app/core/constant/colors.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

enum ButtonType { primary, disabled, secondary, icon }

class CommonButton extends StatelessWidget {
  const CommonButton(
      {Key? key,
      this.child,
      this.buttonType = ButtonType.primary,
      this.text,
      required this.onPressed,
      this.textStyle,
      this.height = 48,
      this.width = double.infinity,
      this.padding = EdgeInsets.zero,
      this.backgroudColor,
      required this.btnController})
      : super(key: key);
  final Widget? child;
  final String? text;
  final ButtonType buttonType;
  final Function()? onPressed;
  final TextStyle? textStyle;
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;
  final Color? backgroudColor;
  final RoundedLoadingButtonController btnController;

  @override
  Widget build(BuildContext context) {
    Color? _backgroundColor;
    Color? textColor;
    switch (buttonType) {
      case ButtonType.primary:
        _backgroundColor = AppColors.primaryColors[500];
        textColor = AppColors.ink[0];
        break;

      case ButtonType.disabled:
        _backgroundColor = Colors.transparent;
        textColor = AppColors.ink[400];
        break;
      case ButtonType.secondary:
        _backgroundColor = AppColors.primaryColors[200];
        textColor = AppColors.primaryColors[500];
        break;

      case ButtonType.icon:
        _backgroundColor = AppColors.ink[500];
        textColor = AppColors.ink[400];
        break;
      default:
    }
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: RoundedLoadingButton(
        color: backgroudColor ?? _backgroundColor,
        child: child ??
            Text(
              text ?? '',
              style: t16M.apply(color: textColor),
            ),
        onPressed: buttonType == ButtonType.disabled ? null : onPressed,
        controller: btnController,
      ),
    );
  }
}
