import 'package:flutter/material.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/home/presentation/widgets/car_mini_details_card_widget.dart';
import 'package:wolfera/generated/assets.dart';

class CarsListViewBuilder extends StatelessWidget {
  final Axis scrollDirection;
  final EdgeInsetsGeometry padding;
  const CarsListViewBuilder({
    super.key,
    required this.scrollDirection,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: scrollDirection,
      padding: scrollDirection == Axis.vertical
          ? HWEdgeInsets.only(bottom: 20, left: 10, right: 10)
          : null,
      itemCount: 4,
      itemBuilder: (context, index) {
        return Padding(
          padding: padding,
          child: CarMiniDetailsCardWidget(
            image: index.isEven ? Assets.imagesBmwStreet : Assets.imagesCar1,
          ),
        );
      },
    );
  }
}
