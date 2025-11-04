import 'package:flutter/material.dart';
import 'package:wolfera/common/enums/car_color.dart';

extension CarColorExtension on CarColor {
  String get displayName {
    switch (this) {
      case CarColor.beige:
        return 'Beige';
      case CarColor.black:
        return 'Black';
      case CarColor.blue:
        return 'Blue';
      case CarColor.white:
        return 'White';
      case CarColor.brown:
        return 'Brown';
      case CarColor.gold:
        return 'Gold';
      case CarColor.green:
        return 'Green';
      case CarColor.grey:
        return 'Grey';
      case CarColor.orange:
        return 'Orange';
      case CarColor.red:
        return 'Red';
      case CarColor.silver:
        return 'Silver';
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
