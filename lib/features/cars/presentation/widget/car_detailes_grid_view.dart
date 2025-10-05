import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/cars/presentation/widget/car_details_with_icon_item.dart';
import 'package:wolfera/generated/assets.dart';

class CarDetailesGridView extends StatelessWidget {
  const CarDetailesGridView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            10.horizontalSpace,
            const CarDetailesWithIconItem(
              path: Assets.svgSpeedometer,
              title: '18,000 KM',
              textWidth: 92,
            ),
            40.horizontalSpace,
            const CarDetailesWithIconItem(
              path: Assets.svgGear,
              title: 'Automatic',
              textWidth: 80,
            ),
            35.horizontalSpace,
            const CarDetailesWithIconItem(
              path: Assets.svgEngineMotor,
              title: '4.0 L V8 Electric',
              textWidth: 85,
            ),
          ],
        ),
        20.verticalSpace,
        Row(
          children: [
            10.horizontalSpace,
            const CarDetailesWithIconItem(
              path: Assets.svgPistonMotor,
              title: '8 Cylinders',
              textWidth: 100,
            ),
            50.horizontalSpace,
            CarDetailesWithIconItem(
              path: Assets.svgGasStation,
              title: 'Petrol',
              textPadding: HWEdgeInsets.only(right: 6),
              textWidth: 50,
            ),
            65.horizontalSpace,
            const CarDetailesWithIconItem(
              path: Assets.svgYear,
              title: '2020',
              textWidth: 32,
            ),
          ],
        )
      ],
    );
  }
}
