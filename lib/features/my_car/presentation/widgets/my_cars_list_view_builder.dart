import 'package:flutter/material.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/home/presentation/widgets/car_mini_details_card_widget.dart';

class MyCarsListViewBuilder extends StatelessWidget {
  const MyCarsListViewBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: 4,
        padding: HWEdgeInsets.only(bottom: 75),
        itemBuilder: (context, index) => Padding(
              padding: HWEdgeInsets.only(top: 20, right: 14, left: 14),
              child: const CarMiniDetailsCardWidget(
                isFaviorateIcon: false,
                isStatus: true,
              ),
            ));
  }
}
