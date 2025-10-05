import 'package:wolfera/common/enums/cylinders.dart';

extension CylindersExtension on Cylinders {
  String get displayName {
    switch (this) {
      case Cylinders.two:
        return '2 Cylinders';
      case Cylinders.three:
        return '3 Cylinders';
      case Cylinders.four:
        return '4 Cylinders';
      case Cylinders.five:
        return '5 Cylinders';
      case Cylinders.six:
        return '6 Cylinders';
      case Cylinders.eight:
        return '8 Cylinders';
      case Cylinders.ten:
        return '10 Cylinders';
      case Cylinders.eleven:
        return '11 Cylinders';
      case Cylinders.twelve:
        return '12 Cylinders';
      case Cylinders.sixteen:
        return '16 Cylinders';
      case Cylinders.none:
        return 'None';
      default:
        return '';
    }
  }
}
