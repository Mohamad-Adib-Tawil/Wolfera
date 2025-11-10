import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/cars/presentation/widget/car_details_with_icon_item.dart';
import 'package:wolfera/generated/assets.dart';

class CarDetailesGridView extends StatelessWidget {
  final Map<String, dynamic> carData;
  
  const CarDetailesGridView({
    super.key,
    required this.carData,
  });

  @override
  Widget build(BuildContext context) {
    final mileageVal = carData['mileage']?.toString() ?? '0';
    final transmissionVal = carData['transmission']?.toString();
    final engineCapacity = carData['engine_capacity'];
    final cylinders = carData['cylinders'];
    final fuelTypeVal = carData['fuel_type']?.toString();
    final yearVal = carData['year']?.toString();
    
    // Format mileage with translation
    String mileageText = '$mileageVal ${'km'.tr()}';
    
    // Format transmission with translation
    String transmissionText = '-';
    if (transmissionVal != null && transmissionVal.isNotEmpty && transmissionVal != 'null') {
      final lowerTransmission = transmissionVal.toLowerCase();
      if (lowerTransmission.contains('auto') && !lowerTransmission.contains('semi')) {
        transmissionText = 'transmission_types.automatic'.tr();
      } else if (lowerTransmission.contains('manual')) {
        transmissionText = 'transmission_types.manual'.tr();
      } else if (lowerTransmission.contains('semi')) {
        transmissionText = 'transmission_types.semi_automatic'.tr();
      } else {
        transmissionText = transmissionVal;
      }
    }
    
    // Format engine capacity
    String engineText = '-';
    if (engineCapacity != null) {
      final engineVal = engineCapacity.toString();
      if (engineVal != 'null' && engineVal.isNotEmpty) {
        engineText = '$engineVal L';
      }
    }
    
    // Format cylinders
    String cylindersText = '-';
    if (cylinders != null) {
      final cylindersVal = cylinders.toString();
      if (cylindersVal != 'null' && cylindersVal.isNotEmpty) {
        cylindersText = '$cylindersVal ${'cylinders'.tr()}';
      }
    }
    
    // Format fuel type with translation
    String fuelTypeText = '-';
    if (fuelTypeVal != null && fuelTypeVal.isNotEmpty && fuelTypeVal != 'null') {
      final lowerFuelType = fuelTypeVal.toLowerCase();
      if (lowerFuelType.contains('gasoline') || lowerFuelType.contains('بنزين')) {
        fuelTypeText = 'fuel_types.gasoline'.tr();
      } else if (lowerFuelType.contains('diesel') || lowerFuelType.contains('ديزل') || lowerFuelType.contains('مازوت')) {
        fuelTypeText = 'fuel_types.diesel'.tr();
      } else if (lowerFuelType.contains('petrol') || lowerFuelType.contains('بترول')) {
        fuelTypeText = 'fuel_types.petrol'.tr();
      } else if (lowerFuelType.contains('electric') || lowerFuelType.contains('كهرباء')) {
        fuelTypeText = 'fuel_types.electric'.tr();
      } else if (lowerFuelType.contains('hybrid') || lowerFuelType.contains('هجين')) {
        fuelTypeText = 'fuel_types.hybrid'.tr();
      } else {
        fuelTypeText = fuelTypeVal;
      }
    }
    
    // Format year with translation
    String yearText = yearVal != null && yearVal.isNotEmpty && yearVal != 'null'
        ? yearVal
        : 'year_model'.tr();
    
    return Column(
      children: [
        Row(
          children: [
            10.horizontalSpace,
            CarDetailesWithIconItem(
              path: Assets.svgSpeedometer,
              title: mileageText,
              textWidth: 92,
            ),
            40.horizontalSpace,
            CarDetailesWithIconItem(
              path: Assets.svgGear,
              title: transmissionText,
              textWidth: 80,
            ),
            35.horizontalSpace,
            CarDetailesWithIconItem(
              path: Assets.svgEngineMotor,
              title: engineText,
              textWidth: 85,
            ),
          ],
        ),
        20.verticalSpace,
        Row(
          children: [
            10.horizontalSpace,
            CarDetailesWithIconItem(
              path: Assets.svgPistonMotor,
              title: cylindersText,
              textWidth: 100,
            ),
            50.horizontalSpace,
            CarDetailesWithIconItem(
              path: Assets.svgGasStation,
              title: fuelTypeText,
              textPadding: HWEdgeInsets.only(right: 6),
              textWidth: 50,
            ),
            65.horizontalSpace,
            CarDetailesWithIconItem(
              path: Assets.svgYear,
              title: yearText,
              textWidth: 32,
            ),
          ],
        )
      ],
    );
  }
}
