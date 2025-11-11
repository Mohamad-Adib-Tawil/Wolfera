import 'package:wolfera/common/enums/cylinders.dart';
import 'package:easy_localization/easy_localization.dart';

extension CylindersExtension on Cylinders {
  String get displayName {
    switch (this) {
      case Cylinders.two:
        return 'cylinders_count.2_cylinders'.tr();
      case Cylinders.three:
        return 'cylinders_count.3_cylinders'.tr();
      case Cylinders.four:
        return 'cylinders_count.4_cylinders'.tr();
      case Cylinders.five:
        return 'cylinders_count.5_cylinders'.tr();
      case Cylinders.six:
        return 'cylinders_count.6_cylinders'.tr();
      case Cylinders.eight:
        return 'cylinders_count.8_cylinders'.tr();
      case Cylinders.ten:
        return 'cylinders_count.10_cylinders'.tr();
      case Cylinders.eleven:
        return 'cylinders_count.11_cylinders'.tr();
      case Cylinders.twelve:
        return 'cylinders_count.12_cylinders'.tr();
      case Cylinders.sixteen:
        return 'cylinders_count.16_cylinders'.tr();
      case Cylinders.none:
        return 'None'.tr();
    }
  }
}
