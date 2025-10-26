import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final mileage = carData['mileage']?.toString() ?? '0';
    final transmission = carData['transmission']?.toString() ?? '-';
    final engineCapacity = carData['engine_capacity'];
    final cylinders = carData['cylinders'];
    final fuelType = carData['fuel_type']?.toString() ?? '-';
    final year = carData['year']?.toString() ?? '-';
    
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
        cylindersText = '$cylindersVal Cylinders';
      }
    }
    
    return Column(
      children: [
        Row(
          children: [
            10.horizontalSpace,
            CarDetailesWithIconItem(
              path: Assets.svgSpeedometer,
              title: '$mileage KM',
              textWidth: 92,
            ),
            40.horizontalSpace,
            CarDetailesWithIconItem(
              path: Assets.svgGear,
              title: transmission,
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
              title: fuelType,
              textPadding: HWEdgeInsets.only(right: 6),
              textWidth: 50,
            ),
            65.horizontalSpace,
            CarDetailesWithIconItem(
              path: Assets.svgYear,
              title: year,
              textWidth: 32,
            ),
          ],
        )
      ],
    );
  }
}
