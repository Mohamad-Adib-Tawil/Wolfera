import 'package:easy_localization/easy_localization.dart';
import 'package:wolfera/common/enums/safety_features.dart';

extension SafetyFeatureExtension on SafetyFeature {
  String get featureName {
    switch (this) {
      case SafetyFeature.airbags:
        return 'safety_features_list.airbags'.tr();
      case SafetyFeature.abs:
        return 'safety_features_list.abs'.tr();
      case SafetyFeature.tractionControl:
        return 'safety_features_list.traction_control'.tr();
      case SafetyFeature.laneDepartureWarning:
        return 'safety_features_list.lane_departure_warning'.tr();
      case SafetyFeature.blindSpotMonitoring:
        return 'safety_features_list.blind_spot_monitoring'.tr();
      case SafetyFeature.adaptiveCruiseControl:
        return 'safety_features_list.adaptive_cruise_control'.tr();
      case SafetyFeature.forwardCollisionWarning:
        return 'safety_features_list.forward_collision_warning'.tr();
      case SafetyFeature.automaticEmergencyBraking:
        return 'safety_features_list.automatic_emergency_braking'.tr();
      case SafetyFeature.rearCrossTrafficAlert:
        return 'safety_features_list.rear_cross_traffic_alert'.tr();
      case SafetyFeature.tirePressureMonitoringSystem:
        return 'safety_features_list.tire_pressure_monitoring'.tr();
      case SafetyFeature.stabilityControl:
        return 'safety_features_list.stability_control'.tr();
      case SafetyFeature.parkingSensors:
        return 'safety_features_list.parking_sensors'.tr();
      case SafetyFeature.rearviewCamera:
        return 'safety_features_list.rearview_camera'.tr();
      case SafetyFeature.hillDescentControl:
        return 'safety_features_list.hill_descent_control'.tr();
      case SafetyFeature.driverDrowsinessMonitoring:
        return 'safety_features_list.driver_drowsiness_monitoring'.tr();
      case SafetyFeature.pedestrianDetection:
        return 'safety_features_list.pedestrian_detection'.tr();
    }
  }
}
