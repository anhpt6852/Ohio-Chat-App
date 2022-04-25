import 'package:flutter/material.dart';

//Change colors as Design

class AppColors {
  AppColors._(); // this basically makes it so you can instantiate this class

  static const Color primary = Color(0xFF5768FF);

  static const Map<int, Color> blue = <int, Color>{
    500: Color(0xFF5768FF),
  };

  static const Map<int, Color> ink = <int, Color>{
    0: Color(0xFFFFFFFF),
    100: Color(0xFFF2F3F4),
    200: Color(0xFFE1E6EB),
    300: Color(0xFFB4B2BC),
    400: Color(0xFF7B8090),
    500: Color(0xFF1F2738),
  };

  static const Map<int, Color> red = <int, Color>{
    100: Color(0xFFFEF3F5),
    200: Color(0xFFFCE7EB),
    300: Color(0xFFF7B8C3),
    400: Color(0xFFE94260),
    500: Color(0xFFE41338),
  };

  static const Map<int, Color> green = <int, Color>{
    100: Color(0xFFDDFDF0),
    200: Color(0xFFCCF9E6),
    300: Color(0xFF4BDDA0),
    400: Color(0xFF4BDDA0),
    500: Color(0xFF1CBB78),
  };
  static const Map<int, Color> orange = <int, Color>{
    100: Color(0xFFFFF9F4),
    200: Color(0xFFFFF2EA),
    300: Color(0xFFFED9C1),
    400: Color(0xFFFD9B5A),
    500: Color(0xFFFD8230),
  };
  static const Map<int, Color> yellow = <int, Color>{
    100: Color(0xFFFFFBED),
    200: Color(0xFFFFF8DD),
    300: Color(0xFFFEF1C1),
    400: Color(0xFFFFE589),
    500: Color(0xFFFFD53E),
  };
  static const Map<int, Color> pink = <int, Color>{
    100: Color(0xFFFFF0FF),
    200: Color(0xFFFEDDFF),
    300: Color(0xFFFEC6FF),
    400: Color(0xFFFD93FF),
    500: Color(0xFFFD79FF),
  };
  static const Map<int, Color> purple = <int, Color>{
    100: Color(0xFFF3E5FF),
    200: Color(0xFFEAD0FF),
    300: Color(0xFFD29AFF),
    400: Color(0xFFBF6FFF),
    500: Color(0xFFA93CFE),
  };
  static const Map<int, Color> matcha = <int, Color>{
    100: Color(0xFFF1FFD2),
    200: Color(0xFFE3FFB5),
    300: Color(0xFFD6FF7E),
    400: Color(0xFFBCEE52),
    500: Color(0xFF88BB1C),
  };

  static const Map<int, Color> primaryColors = <int, Color>{
    100: Color(0xFFF8F8FF),
    200: Color(0xFFE2E5FF),
    300: Color(0xFFAEB7FF),
    400: Color(0xFF7987FF),
    500: Color(0xFF5768FF),
  };

  static const Color backgroundLight = Color(0xFFF8F8FF);
  static const Color backgroundDark = Color(0xFFF2F3F4);
  static const Color iconColor = Color(0xFF555B7C);
}
