import 'package:wolfera/common/enums/interior_features.dart';
import 'package:easy_localization/easy_localization.dart';

extension InteriorFeatureExtension on InteriorFeature {
  String get featureName {
    switch (this) {
      case InteriorFeature.leatherSeats:
        return 'interior_features_list.leather_seats'.tr();
      case InteriorFeature.heatedSeats:
        return 'interior_features_list.heated_seats'.tr();
      case InteriorFeature.ventilatedSeats:
        return 'interior_features_list.ventilated_seats'.tr();
      case InteriorFeature.sunroof:
        return 'interior_features_list.sunroof'.tr();
      case InteriorFeature.moonroof:
        return 'interior_features_list.moonroof'.tr();
      case InteriorFeature.backupCamera:
        return 'interior_features_list.backup_camera'.tr();
      case InteriorFeature.navigationSystem:
        return 'interior_features_list.navigation_system'.tr();
      case InteriorFeature.bluetooth:
        return 'interior_features_list.bluetooth'.tr();
      case InteriorFeature.premiumAudio:
        return 'interior_features_list.premium_audio'.tr();
      case InteriorFeature.cruiseControl:
        return 'interior_features_list.cruise_control'.tr();
      case InteriorFeature.remoteStart:
        return 'interior_features_list.remote_start'.tr();
      case InteriorFeature.keylessEntry:
        return 'interior_features_list.keyless_entry'.tr();
      case InteriorFeature.heatedSteeringWheel:
        return 'interior_features_list.heated_steering_wheel'.tr();
      case InteriorFeature.powerWindows:
        return 'interior_features_list.power_windows'.tr();
      case InteriorFeature.powerSeats:
        return 'interior_features_list.power_seats'.tr();
      case InteriorFeature.thirdRowSeating:
        return 'interior_features_list.third_row_seating'.tr();
      case InteriorFeature.ambientLighting:
        return 'interior_features_list.ambient_lighting'.tr();
      case InteriorFeature.wirelessCharging:
        return 'interior_features_list.wireless_charging'.tr();
      case InteriorFeature.appleCarplay:
        return 'interior_features_list.apple_carplay'.tr();
      case InteriorFeature.androidAuto:
        return 'interior_features_list.android_auto'.tr();
    }
  }
}
