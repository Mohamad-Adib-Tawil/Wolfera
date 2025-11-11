import 'package:easy_localization/easy_localization.dart';
import 'package:wolfera/common/enums/exterior_features.dart';

extension ExteriorFeatureExtension on ExteriorFeature {
  String get featureName {
    switch (this) {
      case ExteriorFeature.alloyWheels:
        return 'exterior_features_list.alloy_wheels'.tr();
      case ExteriorFeature.fogLights:
        return 'exterior_features_list.fog_lights'.tr();
      case ExteriorFeature.sunroof:
        return 'exterior_features_list.sunroof'.tr();
      case ExteriorFeature.roofRails:
        return 'exterior_features_list.roof_rails'.tr();
      case ExteriorFeature.towPackage:
        return 'exterior_features_list.tow_package'.tr();
      case ExteriorFeature.powerLiftgate:
        return 'exterior_features_list.power_liftgate'.tr();
      case ExteriorFeature.ledHeadlights:
        return 'exterior_features_list.led_headlights'.tr();
      case ExteriorFeature.runningBoards:
        return 'exterior_features_list.running_boards'.tr();
      case ExteriorFeature.rearSpoiler:
        return 'exterior_features_list.rear_spoiler'.tr();
      case ExteriorFeature.tintedWindows:
        return 'exterior_features_list.tinted_windows'.tr();
      case ExteriorFeature.heatedSideMirrors:
        return 'exterior_features_list.heated_side_mirrors'.tr();
      case ExteriorFeature.rainSensingWipers:
        return 'exterior_features_list.rain_sensing_wipers'.tr();
      case ExteriorFeature.panoramicSunroof:
        return 'exterior_features_list.panoramic_roof'.tr();
      case ExteriorFeature.roofRack:
        return 'exterior_features_list.roof_rack'.tr();
      case ExteriorFeature.dualExhaust:
        return 'exterior_features_list.dual_exhaust'.tr();
    }
  }
}
