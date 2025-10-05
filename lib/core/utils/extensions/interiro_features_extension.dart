import 'package:wolfera/common/enums/interior_features.dart';

extension InteriorFeatureExtension on InteriorFeature {
  String get featureName {
    switch (this) {
      case InteriorFeature.leatherSeats:
        return 'Leather Seats';
      case InteriorFeature.heatedSeats:
        return 'Heated Seats';
      case InteriorFeature.ventilatedSeats:
        return 'Ventilated Seats';
      case InteriorFeature.sunroof:
        return 'Sunroof';
      case InteriorFeature.moonroof:
        return 'Moonroof';
      case InteriorFeature.backupCamera:
        return 'Backup Camera';
      case InteriorFeature.navigationSystem:
        return 'Navigation System';
      case InteriorFeature.bluetooth:
        return 'Bluetooth';
      case InteriorFeature.premiumAudio:
        return 'Premium Audio';
      case InteriorFeature.cruiseControl:
        return 'Cruise Control';
      case InteriorFeature.remoteStart:
        return 'Remote Start';
      case InteriorFeature.keylessEntry:
        return 'Keyless Entry';
      case InteriorFeature.heatedSteeringWheel:
        return 'Heated Steering Wheel';
      case InteriorFeature.powerWindows:
        return 'Power Windows';
      case InteriorFeature.powerSeats:
        return 'Power Seats';
      case InteriorFeature.thirdRowSeating:
        return 'Third Row Seating';
      case InteriorFeature.ambientLighting:
        return 'Ambient Lighting';
      case InteriorFeature.wirelessCharging:
        return 'Wireless Charging';
      case InteriorFeature.appleCarplay:
        return 'Apple CarPlay';
      case InteriorFeature.androidAuto:
        return 'Android Auto';
      default:
        return '';
    }
  }
}
