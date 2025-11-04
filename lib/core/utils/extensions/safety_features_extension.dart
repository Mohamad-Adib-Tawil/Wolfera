import 'package:wolfera/common/enums/safety_features.dart';

extension SafetyFeatureExtension on SafetyFeature {
  String get featureName {
    switch (this) {
      case SafetyFeature.airbags:
        return 'Airbags';
      case SafetyFeature.abs:
        return 'ABS';
      case SafetyFeature.tractionControl:
        return 'Traction Control';
      case SafetyFeature.laneDepartureWarning:
        return 'Lane Departure Warning';
      case SafetyFeature.blindSpotMonitoring:
        return 'Blind Spot Monitoring';
      case SafetyFeature.adaptiveCruiseControl:
        return 'Adaptive Cruise Control';
      case SafetyFeature.forwardCollisionWarning:
        return 'Forward Collision Warning';
      case SafetyFeature.automaticEmergencyBraking:
        return 'Automatic Emergency Braking';
      case SafetyFeature.rearCrossTrafficAlert:
        return 'Rear Cross Traffic Alert';
      case SafetyFeature.tirePressureMonitoringSystem:
        return 'Tire Pressure Monitoring System';
      case SafetyFeature.stabilityControl:
        return 'Stability Control';
      case SafetyFeature.parkingSensors:
        return 'Parking Sensors';
      case SafetyFeature.rearviewCamera:
        return 'Rearview Camera';
      case SafetyFeature.hillDescentControl:
        return 'Hill Descent Control';
      case SafetyFeature.driverDrowsinessMonitoring:
        return 'Driver Drowsiness Monitoring';
      case SafetyFeature.pedestrianDetection:
        return 'Pedestrian Detection';
    }
  }
}
