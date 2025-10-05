import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/cars/presentation/widget/car_details_item.dart';
import 'package:wolfera/features/cars/presentation/widget/car_name_and_price_row_widget.dart';
import 'package:wolfera/features/cars/presentation/widget/car_detailes_grid_view.dart';
import 'package:wolfera/features/chat/presentation/widgets/white_divider.dart';

class CarDetailsSection extends StatelessWidget {
  const CarDetailsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: HWEdgeInsets.symmetric(horizontal: 11),
      child: Column(
        children: [
          const CarNameAndPriceRowWidget(),
          CustomDivider(color: AppColors.whiteLess, thickness: 1.r),
          5.verticalSpace,
          const CarDetailesGridView(),
          6.verticalSpace,
          CustomDivider(color: AppColors.whiteLess, thickness: 1.r),
          const CarDetailsItem(title: 'Brand', value: 'Ferrari'),
          const CarDetailsItem(title: 'Model', value: 'SF90 Stradale'),
          const CarDetailsItem(title: 'Year Model', value: '2019'),
          const CarDetailsItem(title: 'Trim', value: 'Carbon fiber'),
          const CarDetailsItem(title: 'Paint Parts', value: '3 Parts'),
          const CarDetailsItem(title: 'Seat Number', value: '5'),
          const CarDetailsItem(title: 'Plate', value: 'Berlin'),
          const CarDetailsItem(title: 'Color', value: 'Orange'),
          const CarDetailsItem(
              title: 'Seat Material', value: 'Carlex Original'),
          const CarDetailsItem(title: 'Condition', value: 'Used'),
          const CarDetailsItem(title: 'Wheels', value: '20'),
          const CarDetailsItem(title: 'Vehicle Type', value: 'Super car'),
          const CarDetailsItem(title: 'Gearbox', value: 'Automatic'),
          const CarDetailsItem(title: 'Cylinders', value: '8'),
          const CarDetailsItem(title: 'Interior Color', value: 'Black'),
          const CarDetailsItem(title: 'Exterior Color', value: 'Orange'),
          const CarDetailsItem(title: 'Location', value: 'Germany'),
          10.verticalSpace,
        ],
      ),
    );
  }
}
