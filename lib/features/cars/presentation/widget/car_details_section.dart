import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/cars/presentation/widget/car_details_item.dart';
import 'package:wolfera/features/cars/presentation/widget/car_name_and_price_row_widget.dart';
import 'package:wolfera/features/cars/presentation/widget/car_detailes_grid_view.dart';
import 'package:wolfera/features/chat/presentation/widgets/white_divider.dart';

class CarDetailsSection extends StatelessWidget {
  final Map<String, dynamic> carData;
  
  const CarDetailsSection({
    super.key,
    required this.carData,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: HWEdgeInsets.symmetric(horizontal: 11),
      child: Column(
        children: [
          CarNameAndPriceRowWidget(carData: carData),
          CustomDivider(color: AppColors.whiteLess, thickness: 1.r),
          5.verticalSpace,
          CarDetailesGridView(carData: carData),
          6.verticalSpace,
          CustomDivider(color: AppColors.whiteLess, thickness: 1.r),
          CarDetailsItem(title: 'Brand', value: carData['brand']?.toString() ?? '-'),
          CarDetailsItem(title: 'Model', value: carData['model']?.toString() ?? '-'),
          CarDetailsItem(title: 'Year Model', value: carData['year']?.toString() ?? '-'),
          CarDetailsItem(title: 'Trim', value: carData['trim']?.toString() ?? '-'),
          CarDetailsItem(title: 'Paint Parts', value: carData['paint_parts']?.toString() ?? '-'),
          CarDetailsItem(title: 'Seat Number', value: carData['seats']?.toString() ?? '-'),
          CarDetailsItem(title: 'Plate', value: carData['plate']?.toString() ?? '-'),
          CarDetailsItem(title: 'Color', value: carData['color']?.toString() ?? '-'),
          CarDetailsItem(title: 'Seat Material', value: carData['seat_material']?.toString() ?? '-'),
          CarDetailsItem(title: 'Condition', value: carData['condition']?.toString() ?? '-'),
          CarDetailsItem(title: 'Wheels', value: carData['wheels']?.toString() ?? '-'),
          CarDetailsItem(title: 'Vehicle Type', value: carData['body_type']?.toString() ?? '-'),
          CarDetailsItem(title: 'Gearbox', value: carData['transmission']?.toString() ?? '-'),
          CarDetailsItem(title: 'Cylinders', value: carData['cylinders']?.toString() ?? '-'),
          CarDetailsItem(title: 'Interior Color', value: carData['interior_color']?.toString() ?? '-'),
          CarDetailsItem(title: 'Exterior Color', value: carData['exterior_color']?.toString() ?? '-'),
          CarDetailsItem(title: 'Location', value: carData['location']?.toString() ?? '-'),
          10.verticalSpace,
        ],
      ),
    );
  }
}
