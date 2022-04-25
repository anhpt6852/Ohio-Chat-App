import 'package:flutter/material.dart';
import 'package:ohio_templates/core/constant/colors.dart';

const primaryFont = 'SVN-Gilroy';

const TextStyle t48M = TextStyle(
  fontSize: 48,
  fontWeight: FontWeight.w500,
  height: 56 / 48, // textHeight = fontSize * height = 56 (design)
  fontFamily: primaryFont,
);
const TextStyle t48R = TextStyle(
  fontSize: 48,
  fontWeight: FontWeight.w400,
  height: 56 / 48,
  fontFamily: primaryFont,
);
const TextStyle t30M = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.w500,
  height: 38 / 30,
  fontFamily: primaryFont,
);
const TextStyle t30R = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.w400,
  height: 38 / 30,
  fontFamily: primaryFont,
);
const TextStyle t24M = TextStyle(
  fontSize: 34,
  fontWeight: FontWeight.w500,
  height: 32 / 24,
  fontFamily: primaryFont,
);
const TextStyle t24R = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w400,
  height: 32 / 24,
  fontFamily: primaryFont,
);
const TextStyle t20M = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w500,
  height: 28 / 20,
  fontFamily: primaryFont,
);
const TextStyle t20R = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w400,
  height: 28 / 20,
  fontFamily: primaryFont,
);
const TextStyle t16M = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  height: 24 / 16,
  fontFamily: primaryFont,
);
const TextStyle t16R = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  height: 20 / 16,
  fontFamily: primaryFont,
);
const TextStyle t16B = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w700,
  height: 24 / 16,
  fontFamily: primaryFont,
);
const TextStyle t16R20 = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  height: 20 / 16,
  fontFamily: primaryFont,
);
const TextStyle t14M = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  height: 20 / 14,
  fontFamily: primaryFont,
);
const TextStyle t12M = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  height: 16 / 12,
  fontFamily: primaryFont,
);
const TextStyle t12R = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  height: 16 / 12,
  fontFamily: primaryFont,
);

const TextTheme textTheme = TextTheme(
  // Title
  headline1: t24M,
  headline2: t24R,
  headline3: t20M,
  headline4: t20R,

  // Heading
  subtitle1: t16M,
  subtitle2: t16R20,

  bodyText1: t14M,
  bodyText2: t14M,

  button: t16B,
  caption: t16M,
  overline: t12R,
);

final ThemeData appLightTheme = ThemeData(
  textTheme: textTheme.apply(
    bodyColor: AppColors.ink[500],
    displayColor: AppColors.ink[500],
  ),
  iconTheme: const IconThemeData(color: AppColors.iconColor),
  brightness: Brightness.light,
  primaryColor: AppColors.primary,
  primaryColorBrightness: Brightness.dark,
  appBarTheme: AppBarTheme(
    color: AppColors.ink[0],
    // backgroundColor: AppColors.backgroundLight,
    elevation: 1,
    iconTheme: const IconThemeData(color: AppColors.iconColor),
    actionsIconTheme: const IconThemeData(color: AppColors.iconColor),
  ),
  scaffoldBackgroundColor: AppColors.backgroundLight,
  bottomSheetTheme:
      const BottomSheetThemeData(backgroundColor: AppColors.backgroundLight),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(decorationColor: AppColors.ink[500]),
  ),
);
