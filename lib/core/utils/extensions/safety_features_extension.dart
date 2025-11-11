import 'package:easy_localization/easy_localization.dart';
import 'package:wolfera/common/enums/safety_features.dart';

extension SafetyFeatureExtension on SafetyFeature {
  String get featureName {
    switch (this) {
      case SafetyFeature.airbags:
        return 'airbags'.tr();
      case SafetyFeature.abs:
        return 'abs'.tr();
      case SafetyFeature.tractionControl:
        return 'traction_control'.tr();
      case SafetyFeature.laneDepartureWarning:
        return "lane_departure_warning".tr();
      case SafetyFeature.blindSpotMonitoring:
        return 'blind_spot_monitoring'.tr();
      case SafetyFeature.adaptiveCruiseControl:
        return 'adaptive_cruise_control'.tr();
      case SafetyFeature.forwardCollisionWarning:
        return 'forward_collision_warning'.tr();
      case SafetyFeature.automaticEmergencyBraking:
        return 'automatic_emergency_braking'.tr();
      case SafetyFeature.rearCrossTrafficAlert:
        return 'Rear Cross Traffic Alert'.tr();
      case SafetyFeature.tirePressureMonitoringSystem:
        return 'tire_pressure_monitoring'.tr();
      case SafetyFeature.stabilityControl:
        return 'stability_control'.tr();
      case SafetyFeature.parkingSensors:
        return 'parking_sensors'.tr();
      case SafetyFeature.rearviewCamera:
        return 'Rearview Camera'.tr();
      case SafetyFeature.hillDescentControl:
        return 'Hill Descent Control'.tr();
      case SafetyFeature.driverDrowsinessMonitoring:
        return 'Driver Drowsiness Monitoring'.tr();
      case SafetyFeature.pedestrianDetection:
        return 'Pedestrian Detection'.tr();
    }
  }
}
