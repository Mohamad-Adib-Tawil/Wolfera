import 'package:wolfera/common/enums/seats_filter.dart';

extension SeatsExtension on Seats {
  String get displayName {
    switch (this) {
      case Seats.two:
        return '2 Seats';
      case Seats.three:
        return '3 Seats';
      case Seats.four:
        return '4 Seats';
      case Seats.five:
        return '5 Seats';
      case Seats.six:
        return '6 Seats';
      case Seats.seven:
        return '7 Seats';
      case Seats.eight:
        return '8 Seats';
      case Seats.ninePlus:
        return '9+ Seats';
      default:
        return '';
    }
  }
}
