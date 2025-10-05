import 'package:flutter/material.dart';

abstract class AppColors {
  const AppColors._();

  static const MaterialColor primary = MaterialColor(
    _primaryPrimaryValue,
    <int, Color>{
      50: Color(0xFFFFF3E0), // Light shade of orange
      100: Color(0xFFFFE0B2), // Lighter shade of orange
      200: Color(0xFFFFCC80), // Light orange
      300: Color(0xFFFFB74D), // Medium light orange
      400: Color(0xFFFFA726), // Medium orange
      500: Color(_primaryPrimaryValue), // Primary value
      600: Color(0xFFFB8C00), // Slightly darker orange
      700: Color(0xFFF57C00), // Darker orange
      800: Color(0xFFEF6C00), // Even darker orange
      900: Color(0xFFE65100), // Darkest orange
    },
  );

  static const int _primaryPrimaryValue = 0xFFF7931E;

  static const MaterialColor dark = MaterialColor(
    _darkPrimaryValue,
    <int, Color>{
      50: Color(0xFFE5E5E7), // Lightest shade
      100: Color(0xFFBDBDC1), // Lighter shade
      200: Color(0xFF96969A), // Light shade
      300: Color(0xFF6F6F73), // Medium light shade
      400: Color(0xFF515155), // Medium shade
      500: Color(_darkPrimaryValue), // Primary value
      600: Color(0xFF26252D), // Slightly darker
      700: Color(0xFF1F1F25), // Darker
      800: Color(0xFF18181C), // Even darker
      900: Color(0xFF121214), // Darkest
    },
  );

  static const int _darkPrimaryValue = 0xFF2C2B34;

  static const MaterialColor grey = MaterialColor(
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

  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color blackLight = Color(0xff2C2B34);
  static const Color whiteLess = Color(0xffD9D9D9);
  static const Color green = Color(0xff2CC56F);
  static const Color orange = Color(0xffF7931E);
  static const Color red = Color(0xffEA574E);
  static const Color blue = Color(0xffcdecfa);
  static const Color greyStroke = Color(0xffA2A2A2);
  static const Color purple = Color(0xff7367F0);
  static const Color burgundy = Color(0xff800020);
  static const Color brown = Color(0xff914800);
  
}

Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

Color lighten(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}
