import 'package:flutter/material.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/home/presentation/widgets/car_mini_details_card_widget.dart';
import 'package:wolfera/generated/assets.dart';
import 'package:wolfera/core/utils/money_formatter.dart';
import 'package:wolfera/core/utils/car_value_translator.dart';

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
        
        // Translate spec1 (body_type or engine_capacity)
        final rawSpec1 = car['body_type']?.toString();
        final spec1 = rawSpec1 != null
            ? CarValueTranslator.translateBodyType(rawSpec1)
            : car['engine_capacity']?.toString();
        
        // Translate spec2 (transmission)
        final rawSpec2 = car['transmission']?.toString();
        final spec2 = rawSpec2 != null
            ? CarValueTranslator.translateTransmission(rawSpec2)
            : null;
        
        final mileageVal = car['mileage']?.toString();
        final mileage = mileageVal;
        
        // Translate fuel type
        final rawFuel = car['fuel_type']?.toString();
        final fuel = rawFuel != null
            ? CarValueTranslator.translateFuelType(rawFuel)
            : null;
        
        // Translate location/country: prefer country, include city if present
        final city = car['city']?.toString();
        final countryRaw = car['country']?.toString();
        final locationRaw = car['location']?.toString();
        String? location;
        if (city != null && city.isNotEmpty && countryRaw != null && countryRaw.isNotEmpty) {
          final c = CarValueTranslator.translateCountry(countryRaw);
          final tCity = CarValueTranslator.translateCity(city, country: countryRaw);
          location = '${tCity.isNotEmpty ? tCity : city}, ${c != '-' ? c : countryRaw}';
        } else if (countryRaw != null && countryRaw.isNotEmpty) {
          final c = CarValueTranslator.translateCountry(countryRaw);
          location = c != '-' ? c : countryRaw;
        } else if (city != null && city.isNotEmpty) {
          final tCity = CarValueTranslator.translateCity(city, country: countryRaw);
          location = tCity.isNotEmpty ? tCity : city;
        } else if (locationRaw != null && locationRaw.isNotEmpty) {
          final c = CarValueTranslator.translateCountry(locationRaw);
          location = c != '-' ? c : locationRaw;
        }
        final priceVal = car['price']?.toString();
        final currency = car['currency']?.toString() ?? '\$';
        // Choose displayed price based on listing type
        final listingType = car['listing_type']?.toString().toLowerCase();
        String? price;
        // Prefer rental price for 'rent' and 'both'
        if (listingType == 'rent' || listingType == 'both') {
          final candidates = [
            ['rental_price_per_day', 'day'],
            ['rental_price_per_week', 'week'],
            ['rental_price_per_month', 'month'],
            ['rental_price_per_3months', '3 months'],
            ['rental_price_per_6months', '6 months'],
            ['rental_price_per_year', 'year'],
          ];
          for (final c in candidates) {
            final raw = car[c[0]];
            if (raw != null) {
              final num? v = raw is num ? raw : num.tryParse(raw.toString());
              if (v != null) {
                final compact = MoneyFormatter.compact(v, symbol: currency);
                price = compact != null ? '$compact / ${c[1]}' : null;
                break;
              }
            }
          }
          // Fallback to sale price if no rental value was found and it's 'both'
          if (price == null && listingType == 'both') {
            price = MoneyFormatter.compactFromString(priceVal, symbol: currency);
          }
        } else {
          price = MoneyFormatter.compactFromString(priceVal, symbol: currency);
        }

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
