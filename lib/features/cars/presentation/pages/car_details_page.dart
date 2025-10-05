import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/cars/presentation/widget/car_description.dart';
import 'package:wolfera/features/cars/presentation/widget/car_details_section.dart';
import 'package:wolfera/features/cars/presentation/widget/car_detalis_appbar.dart';
import 'package:wolfera/features/cars/presentation/widget/car_image_viewer.dart';
import 'package:wolfera/features/cars/presentation/widget/features_list_view.dart';
import 'package:wolfera/features/cars/presentation/widget/more_images_cars_list.dart';
import 'package:wolfera/features/cars/presentation/widget/seller_sction_detalis.dart';
import 'package:wolfera/features/cars/presentation/widget/similar_car_list_view.dart';
import 'package:wolfera/features/chat/presentation/widgets/white_divider.dart';

class CarDetailsPage extends StatelessWidget {
  const CarDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
            const CarDescription(
              description:
                  "This SF90 Stradale is the first plug-in hybrid from the brand with the prancing horse, but Ferrari proves that adding a battery is not only interesting for CO2 emissions: thanks to This SF90 Stradale is the first plug-in hybrid from the brand but Ferrari proves that adding a battery is not only interesting",
            ),
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
