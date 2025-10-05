import 'package:flutter/material.dart';

extension MyColorScheme on ColorScheme {
  static const MaterialColor _grey = MaterialColor(
    _greyPrimaryValue,
    <int, Color>{
      50: Color(0xFFF7F7F7), // Lightest shade of grey
      100: Color(0xFFE1E1E1), // Lighter shade of grey
      200: Color(0xFFCCCCCC), // Light grey
      300: Color(0xFFB6B6B6), // Medium light grey
      400: Color(0xFFAFAFAF), // Medium grey
      500: Color(_greyPrimaryValue), // Primary grey value
      600: Color(0xFF8A8A8A), // Slightly darker grey
      700: Color(0xFF757575), // Darker grey
      800: Color(0xFF616161), // Even darker grey
      900: Color(0xFF4D4D4D), // Darkest grey
    },
  );

  static const int _greyPrimaryValue = 0xFFA2A2A2;


  static const MaterialColor _hint = MaterialColor(
    _primaryHintValue,
    <int, Color>{
      100: Color(0xffF2F3F3),
    },
  );

  static const int _primaryHintValue = 0xffADADAD;

  static const MaterialColor _drawer = MaterialColor(
    _primaryDrawerValue,
    <int, Color>{},
  );

  static const int _primaryDrawerValue = 0xff2A2E43;

  static const MaterialColor _white = MaterialColor(
    _primaryWhiteValue,
    <int, Color>{},
  );

  static const int _primaryWhiteValue = 0xffFEFEFE;

  MaterialColor get hint => brightness == Brightness.light ? _hint : _hint;

  Color get borderTextField =>
      brightness == Brightness.light ? _hint.shade100 : _grey.shade600;

  Color get grey100 =>
      brightness == Brightness.light ? _grey.shade100 : _grey.shade100;

  Color get grey150 => const Color(0xffE1E1E1);

  Color get grey200 =>
      brightness == Brightness.light ? _grey.shade200 : _grey.shade200;

  Color get grey300 =>
      brightness == Brightness.light ? _grey.shade300 : _grey.shade300;

  Color get grey =>
      brightness == Brightness.light ? _grey.shade400 : _grey.shade400;

  Color get grey50 =>
      brightness == Brightness.light ? _grey.shade50 : _grey.shade50;

  Color get grey500 =>
      brightness == Brightness.light ? _grey.shade500 : _grey.shade500;

  Color get grey600 =>
      brightness == Brightness.light ? _grey.shade600 : _grey.shade600;

  Color get greyBorder =>
      brightness == Brightness.light ? _grey.shade50 : _grey.shade50;

  Color get drawer => brightness == Brightness.light ? _drawer : _drawer;

  Color get white => brightness == Brightness.light ? _white : _white;

  Color get grey700 =>
      brightness == Brightness.light ? _grey.shade700 : _grey.shade700;

  Color get grey800 =>
      brightness == Brightness.light ? _grey.shade700 : _grey.shade700;

  Color get dividerColor => const Color(0xffDFDFDF);

  Color get black => const Color(0xff000000);

  Color get blue => const Color(0xff0080FF);

  Color get pink => const Color(0xffEE7BB7);
}
