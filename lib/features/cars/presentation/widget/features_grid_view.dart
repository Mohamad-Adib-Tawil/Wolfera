import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/cars/presentation/widget/car_feature_item.dart';

class FeaturesGridView extends StatelessWidget {
  final List<String> features;
  
  const FeaturesGridView({
    super.key,
    this.features = const [],
  });

  @override
  Widget build(BuildContext context) {
    if (features.isEmpty) {
      return const SizedBox.shrink();
    }
    
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
        itemCount: features.length,
        padding: HWEdgeInsets.only(bottom: 20, top: 2),
        itemBuilder: (context, index) {
          return CarFeautreItem(featureName: features[index]);
        },
      ),
    );
  }
}
