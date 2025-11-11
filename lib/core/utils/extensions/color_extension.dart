import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wolfera/common/enums/car_color.dart';

extension CarColorExtension on CarColor {
  String get displayName {
    switch (this) {
      case CarColor.beige:
        return 'colors.beige'.tr();
      case CarColor.black:
        return 'colors.black'.tr();
      case CarColor.blue:
        return 'colors.blue'.tr();
      case CarColor.white:
        return 'colors.white'.tr();
      case CarColor.brown:
        return 'colors.brown'.tr();
      case CarColor.gold:
        return 'colors.gold'.tr();
      case CarColor.green:
        return 'colors.green'.tr();
      case CarColor.grey:
        return 'colors.grey'.tr();
      case CarColor.orange:
        return 'colors.orange'.tr();
      case CarColor.red:
        return 'colors.red'.tr();
      case CarColor.silver:
        return 'colors.silver'.tr();
    }
  }

  Color get colorValue {
    switch (this) {
      case CarColor.beige:
        return const Color(0xFFF5F5DC);
      case CarColor.black:
        return Colors.black;
      case CarColor.blue:
        return Colors.blue;
      case CarColor.white:
        return Colors.white;
      case CarColor.brown:
        return Colors.brown;
      case CarColor.gold:
        return const Color(0xFFFFD700);
      case CarColor.green:
        return Colors.green;
      case CarColor.grey:
        return Colors.grey;
      case CarColor.orange:
        return Colors.orange;
      case CarColor.red:
        return Colors.red;
      case CarColor.silver:
        return const Color(0xFFC0C0C0);
    }
  }
}
