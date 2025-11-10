import 'package:wolfera/common/enums/seats_filter.dart';
import 'package:easy_localization/easy_localization.dart';

extension SeatsExtension on Seats {
  String get displayName {
    switch (this) {
      case Seats.two:
        return 'seats_count.2_seats'.tr();
      case Seats.three:
        return 'seats_count.3_seats'.tr();
      case Seats.four:
        return 'seats_count.4_seats'.tr();
      case Seats.five:
        return 'seats_count.5_seats'.tr();
      case Seats.six:
        return 'seats_count.6_seats'.tr();
      case Seats.seven:
        return 'seats_count.7_seats'.tr();
      case Seats.eight:
        return 'seats_count.8_seats'.tr();
      case Seats.ninePlus:
        return 'seats_count.9_plus_seats'.tr();
    }
  }
}
