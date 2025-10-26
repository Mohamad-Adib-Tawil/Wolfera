import 'package:flutter/material.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/home/presentation/widgets/car_mini_details_card_widget.dart';
import 'package:wolfera/generated/assets.dart';

class CarsListViewBuilder extends StatelessWidget {
  final Axis scrollDirection;
  final EdgeInsetsGeometry padding;
  final List<Map<String, dynamic>>? cars;
  const CarsListViewBuilder({
    super.key,
    required this.scrollDirection,
    required this.padding,
    this.cars,
  });

  @override
  Widget build(BuildContext context) {
    final list = cars;
    return ListView.builder(
      scrollDirection: scrollDirection,
      padding: scrollDirection == Axis.vertical
          ? HWEdgeInsets.only(bottom: 20, left: 10, right: 10)
          : null,
      itemCount: list?.length ?? 4,
      itemBuilder: (context, index) {
        if (list == null) {
          return Padding(
            padding: padding,
            child: CarMiniDetailsCardWidget(
              image: index.isEven ? Assets.imagesBmwStreet : Assets.imagesCar1,
            ),
          );
        }

        final car = list[index];
        final images = (car['carImages'] as List?)?.cast<dynamic>() ?? const [];
        final imageUrl = images.isNotEmpty ? images.first?.toString() : null;
        final title = [car['carYear'], car['carMaker'], car['carModel']]
            .where((e) => e != null && e.toString().isNotEmpty)
            .join(' ');
        final spec1 = (car['carTrim'] ?? car['carEngine'])?.toString();
        final spec2 = car['carTransmission']?.toString();
        final mileageVal = car['carMileage']?.toString();
        final mileage = mileageVal != null && mileageVal.isNotEmpty
            ? '$mileageVal KM'
            : null;
        final fuel = car['carFuelType']?.toString();
        final location = car['carLocation']?.toString();
        final priceVal = car['carPrice']?.toString();
        final price = priceVal != null && priceVal.isNotEmpty
            ? '${priceVal}\$'
            : null;

        return Padding(
          padding: padding,
          child: CarMiniDetailsCardWidget(
            image: imageUrl,
            title: title.isNotEmpty ? title : null,
            spec1: spec1,
            spec2: spec2,
            mileage: mileage,
            fuel: fuel,
            location: location,
            price: price,
          ),
        );
      },
    );
  }
}
