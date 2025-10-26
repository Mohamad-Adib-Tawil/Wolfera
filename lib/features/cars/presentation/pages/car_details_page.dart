import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/cars/presentation/widget/car_description.dart';
import 'package:wolfera/features/cars/presentation/widget/car_details_section.dart';
import 'package:wolfera/features/cars/presentation/widget/car_detalis_appbar.dart';
import 'package:wolfera/features/cars/presentation/widget/features_list_view.dart';
import 'package:wolfera/features/cars/presentation/widget/more_images_cars_list.dart';
import 'package:wolfera/features/cars/presentation/widget/seller_sction_detalis.dart';
import 'package:wolfera/features/cars/presentation/widget/similar_car_list_view.dart';
import 'package:wolfera/features/chat/presentation/widgets/white_divider.dart';

class CarDetailsPage extends StatelessWidget {
  final Map<String, dynamic>? carData;
  
  const CarDetailsPage({super.key, this.carData});

  @override
  Widget build(BuildContext context) {
    final data = carData ?? {};
    final description = data['description']?.toString() ?? '';
    
    return Scaffold(
      appBar: const CarDetalisAppbar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            8.verticalSpace,
            const MoreImagesCarsList(),
            10.verticalSpace,
            const CarDetailsSection(),
            const FeaturesListView(),
            Padding(
              padding: HWEdgeInsets.symmetric(horizontal: 11),
              child:
                  CustomDivider(color: AppColors.whiteLess, thickness: 0.6.r),
            ),
            if (description.isNotEmpty)
              CarDescription(description: description),
            Padding(
              padding:
                  HWEdgeInsets.only(left: 11, right: 11, top: 10, bottom: 5),
              child:
                  CustomDivider(color: AppColors.whiteLess, thickness: 0.6.r),
            ),
            const SellerSctionDetalis(),
            const SimilarCarsListView()
          ],
        ),
      ),
    );
  }
}
