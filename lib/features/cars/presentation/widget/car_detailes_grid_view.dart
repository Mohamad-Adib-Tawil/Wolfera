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
    final engineCapacity = carData['engine_capacity']?.toString() ?? '-';
    final cylinders = carData['cylinders']?.toString() ?? '-';
    final fuelType = carData['fuel_type']?.toString() ?? '-';
    final year = carData['year']?.toString() ?? '-';
    
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
              title: '$engineCapacity L',
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
              title: '$cylinders Cylinders',
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
