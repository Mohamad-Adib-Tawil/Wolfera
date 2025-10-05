import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/cars/presentation/widget/car_feature_item.dart';

class FeaturesGridView extends StatelessWidget {
  const FeaturesGridView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: HWEdgeInsets.only(
        left: 16,
        right: 16,
      ),
      child: MasonryGridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        mainAxisSpacing: 10.w,
        crossAxisSpacing: 12.h,
        itemCount: 10,
        padding: HWEdgeInsets.only(bottom: 20, top: 2),
        itemBuilder: (context, index) {
          return const CarFeautreItem(featureName: "Airbags (front and side)");
        },
      ),
    );
  }
}
