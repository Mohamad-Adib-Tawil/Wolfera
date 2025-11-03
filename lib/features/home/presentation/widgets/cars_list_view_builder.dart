import 'package:flutter/material.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/home/presentation/widgets/car_mini_details_card_widget.dart';
import 'package:wolfera/generated/assets.dart';
import 'package:wolfera/core/utils/money_formatter.dart';

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
        
        // Get images from image_urls (jsonb array) or main_image_url
        final imageUrls = (car['image_urls'] as List?)?.cast<dynamic>() ?? const [];
        final mainImage = car['main_image_url']?.toString();
        final imageUrl = imageUrls.isNotEmpty 
            ? imageUrls.first?.toString() 
            : mainImage;
        
        // Build title from year, brand, model
        final title = [
          car['year']?.toString(),
          car['brand']?.toString(),
          car['model']?.toString()
        ].where((e) => e != null && e.isNotEmpty).join(' ');
        
        final spec1 = (car['body_type'] ?? car['engine_capacity'])?.toString();
        final spec2 = car['transmission']?.toString();
        final mileageVal = car['mileage']?.toString();
        final mileage = mileageVal != null && mileageVal.isNotEmpty
            ? '$mileageVal KM'
            : null;
        final fuel = car['fuel_type']?.toString();
        final location = (car['city'] ?? car['location'])?.toString();
        final priceVal = car['price']?.toString();
        final currency = car['currency']?.toString() ?? '\$';
        final price = MoneyFormatter.compactFromString(priceVal, symbol: currency);

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
            carData: car, // Pass the full car data
          ),
        );
      },
    );
  }
}
