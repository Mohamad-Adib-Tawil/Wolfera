import 'package:wolfera/common/enums/exterior_features.dart';

extension ExteriorFeatureExtension on ExteriorFeature {
  String get featureName {
    switch (this) {
      case ExteriorFeature.alloyWheels:
        return 'Alloy Wheels';
      case ExteriorFeature.fogLights:
        return 'Fog Lights';
      case ExteriorFeature.sunroof:
        return 'Sunroof';
      case ExteriorFeature.roofRails:
        return 'Roof Rails';
      case ExteriorFeature.towPackage:
        return 'Tow Package';
      case ExteriorFeature.powerLiftgate:
        return 'Power Liftgate';
      case ExteriorFeature.ledHeadlights:
        return 'LED Headlights';
      case ExteriorFeature.runningBoards:
        return 'Running Boards';
      case ExteriorFeature.rearSpoiler:
        return 'Rear Spoiler';
      case ExteriorFeature.tintedWindows:
        return 'Tinted Windows';
      case ExteriorFeature.heatedSideMirrors:
        return 'Heated Side Mirrors';
      case ExteriorFeature.rainSensingWipers:
        return 'Rain Sensing Wipers';
      case ExteriorFeature.panoramicSunroof:
        return 'Panoramic Sunroof';
      case ExteriorFeature.roofRack:
        return 'Roof Rack';
      case ExteriorFeature.dualExhaust:
        return 'Dual Exhaust';
    }
  }
}
