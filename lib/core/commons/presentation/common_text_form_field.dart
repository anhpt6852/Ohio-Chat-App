import 'package:flutter/material.dart';
import 'package:ohio_chat_app/core/config/theme.dart';
import 'package:ohio_chat_app/core/constant/colors.dart';

class CommonTextFormField extends StatefulWidget {
  final FocusNode? focusNode;
  final FormFieldValidator<String>? validator;
  final String? labelText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool? obscureText;
  final ValueChanged<String>? onFieldSubmitted;
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onChanged;
  final Widget? prefixIcon;
  final bool? autofocus;
  final Widget? suffixIcon;
  final int? maxLines;
  final double? height;
  final String? hintText;
  final bool? alignLabelWithHint;
  final bool? enabled;
  final bool readOnly;
  final bool? withAction;
  final Color? backgroundColor;
  final Color? textColor;
  // final AutovalidateMode? autovalidateMode;
  final BoxConstraints? prefixBoxConstrains;
  final BoxConstraints? sufflixBoxConstrains;

  const CommonTextFormField(
      {Key? key,
      this.focusNode,
      this.validator,
      this.labelText,
      this.controller,
      this.keyboardType,
      this.textInputAction,
      this.onFieldSubmitted,
      this.onChanged,
      this.onTap,
      this.autofocus = false,
      this.obscureText = false,
      this.prefixIcon,
      this.suffixIcon,
      this.maxLines,
      this.height,
      this.hintText,
      this.enabled = true,
      this.readOnly = false,
      this.withAction = false,
      this.backgroundColor,
      this.textColor,
      this.alignLabelWithHint,
      // this.autovalidateMode,
      this.sufflixBoxConstrains,
      this.prefixBoxConstrains})
      : super(key: key);

  @override
  _CommonTextFormFieldState createState() => _CommonTextFormFieldState();
}

class _CommonTextFormFieldState extends State<CommonTextFormField> {
  FocusNode? _focusNode;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode;
    } else {
      _focusNode = FocusNode();
    }
    _focusNode?.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.focusNode == null) _focusNode?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(children: [
        Container(
          height: widget.height ?? 56,
          decoration: BoxDecoration(
              border: Border.all(
                  color: widget.readOnly
                      ? (AppColors.ink[200])!
                      : _focusNode!.hasFocus
                          ? (widget.textColor ?? AppColors.blue[500])!
                          : (widget.textColor != null
                              ? Colors.black
                              : AppColors.ink[200])!),
              color: widget.backgroundColor ?? AppColors.ink[0],
              borderRadius: BorderRadius.circular(8.0)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: [
            Expanded(
                child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              focusNode: _focusNode,
              cursorColor: AppColors.blue[500],
              autofocus: (widget.autofocus)!,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                isDense: false,
                errorStyle: t14M,
                border: InputBorder.none,
                labelText: widget.labelText,
                hintText: widget.hintText,
                hintMaxLines: 2,
                alignLabelWithHint: widget.alignLabelWithHint,
                hintStyle: t16R.copyWith(
                    color: widget.textColor ?? AppColors.ink[400]),
                labelStyle: _focusNode!.hasFocus
                    ? t16R.copyWith(color: AppColors.ink[400])
                    : t16R.copyWith(color: AppColors.ink[400]),
                prefixIcon: widget.prefixIcon,
                prefixIconConstraints: widget.prefixBoxConstrains,
                suffixIcon: widget.suffixIcon,
                suffixIconConstraints: widget.sufflixBoxConstrains,
              ),
              onFieldSubmitted: widget.onFieldSubmitted,
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              maxLines: widget.maxLines ?? 1,
              obscureText: (widget.obscureText)!,
              validator: widget.validator,
              onTap: widget.onTap,
              enabled: widget.enabled,
              readOnly: widget.readOnly,
              onChanged: widget.onChanged,
              style:
                  t16R.copyWith(color: widget.textColor ?? AppColors.ink[500]),
            )),
          ]),
        )
      ]),
    );
  }
}
