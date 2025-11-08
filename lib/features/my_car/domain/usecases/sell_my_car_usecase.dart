import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:wolfera/core/api/result.dart';
import 'package:wolfera/core/config/use_case/use_case.dart';
import 'package:wolfera/features/my_car/data/data_sources/my_car_datasouce.dart';

@injectable
class SellMyCarUsecase extends UseCase<Result<bool>, SellMyCarParams> {
  final MyCarDatasouce _datasouce;

  SellMyCarUsecase(this._datasouce);
  @override
  Future<Result<bool>> call(SellMyCarParams params) {
    return _datasouce.sellMyCar(params);
  }
}

class SellMyCarParams {
  final String userId;
  final String location;
  final String status;
  final String currency; // currency symbol to display (e.g., $, €, ل.س)
  final String carMaker;
  final String carModel;
  final String carEngine;
  final String carYear;
  final String carTransmission;
  final String carMileage;
  final String carFuelType;
  final String carTrim;
  final String carCylinders;
  final String carSeats;
  final String carPaintParts;
  final String carCondition;
  final String carPlate;
  final String carColor;
  final String carSeatMaterial;
  final String carWheels;
  final String carVehicleType;
  final String carInteriorColor;
  final String carExteriorColor;
  final List<String> carSafety;
  final List<String> carExteriorFeatures;
  final List<String> carInteriorFeatures;
  final String carDescription;
  final String carPrice;
  final String carLocation;
  final List<File?> carImages;
  final String? warranty;
  final DateTime? createAt;
  final DateTime? updateAt;
  // Listing type and rental prices
  final String? listingType;
  final String? rentalPricePerDay;
  final String? rentalPricePerWeek;
  final String? rentalPricePerMonth;
  final String? rentalPricePerThreeMonths;
  final String? rentalPricePerSixMonths;
  final String? rentalPricePerYear;

  SellMyCarParams({
    required this.userId,
    required this.location,
    required this.status,
    required this.currency,
    required this.carMaker,
    required this.carModel,
    required this.carEngine,
    required this.carYear,
    required this.carTransmission,
    required this.carMileage,
    required this.carFuelType,
    required this.carTrim,
    required this.carCylinders,
    required this.carSeats,
    required this.carPaintParts,
    required this.carCondition,
    required this.carPlate,
    required this.carColor,
    required this.carSeatMaterial,
    required this.carWheels,
    required this.carVehicleType,
    required this.carInteriorColor,
    required this.carExteriorColor,
    required this.carSafety,
    required this.carExteriorFeatures,
    required this.carInteriorFeatures,
    required this.carDescription,
    required this.carPrice,
    required this.carLocation,
    required this.carImages,
    this.warranty,
    this.createAt,
    this.updateAt,
    this.listingType,
    this.rentalPricePerDay,
    this.rentalPricePerWeek,
    this.rentalPricePerMonth,
    this.rentalPricePerThreeMonths,
    this.rentalPricePerSixMonths,
    this.rentalPricePerYear,
  });

  Map<String, dynamic> toMapWithUrls(List<String> uploadedUrls) {
    // Generate title from car details
    final titleParts = [carYear, carMaker, carModel]
        .where((e) => e.isNotEmpty)
        .join(' ');
    final title = titleParts.isNotEmpty ? titleParts : 'Car for Sale';
    
    final normalizedCity = (carLocation.trim().isEmpty) ? null : carLocation;
    final normalizedCountry = (location.trim().isEmpty || location == 'Worldwide') ? null : location;

    return {
      // Required fields
      'user_id': userId,
      'title': title,
      
      // Core car details
      'brand': carMaker,
      'model': carModel,
      'year': int.tryParse(carYear),
      'price': num.tryParse(carPrice),
      'currency': currency,
      'mileage': int.tryParse(carMileage),
      'transmission': carTransmission,
      'fuel_type': carFuelType,
      'body_type': carVehicleType,
      'color': carColor,
      'engine_capacity': num.tryParse(carEngine),
      'cylinders': int.tryParse(carCylinders),
      'seats': int.tryParse(carSeats),
      'condition': carCondition,
      
      // Additional car details
      'trim': carTrim.isNotEmpty ? carTrim : null,
      'paint_parts': carPaintParts.isNotEmpty ? carPaintParts : null,
      'plate': carPlate.isNotEmpty ? carPlate : null,
      'seat_material': carSeatMaterial.isNotEmpty ? carSeatMaterial : null,
      'wheels': carWheels.isNotEmpty ? carWheels : null,
      'interior_color': carInteriorColor.isNotEmpty ? carInteriorColor : null,
      'exterior_color': carExteriorColor.isNotEmpty ? carExteriorColor : null,
      
      // Location
      'location': normalizedCity,
      'city': normalizedCity,
      'country': normalizedCountry,
      
      // Images
      'main_image_url': uploadedUrls.isNotEmpty ? uploadedUrls.first : null,
      'image_urls': uploadedUrls,
      
      // Features (as JSON arrays)
      'safety_features': carSafety,
      'interior_features': carInteriorFeatures,
      'exterior_features': carExteriorFeatures,
      
      // Description
      'description': carDescription,
      
      // Status
      'status': status.toLowerCase(),
      
      // Listing type and rental prices
      'listing_type': listingType ?? 'sale',
      'rental_price_per_day': rentalPricePerDay != null && rentalPricePerDay!.isNotEmpty ? num.tryParse(rentalPricePerDay!) : null,
      'rental_price_per_week': rentalPricePerWeek != null && rentalPricePerWeek!.isNotEmpty ? num.tryParse(rentalPricePerWeek!) : null,
      'rental_price_per_month': rentalPricePerMonth != null && rentalPricePerMonth!.isNotEmpty ? num.tryParse(rentalPricePerMonth!) : null,
      'rental_price_per_3months': rentalPricePerThreeMonths != null && rentalPricePerThreeMonths!.isNotEmpty ? num.tryParse(rentalPricePerThreeMonths!) : null,
      'rental_price_per_6months': rentalPricePerSixMonths != null && rentalPricePerSixMonths!.isNotEmpty ? num.tryParse(rentalPricePerSixMonths!) : null,
      'rental_price_per_year': rentalPricePerYear != null && rentalPricePerYear!.isNotEmpty ? num.tryParse(rentalPricePerYear!) : null,
      
      // Warranty
      'warranty': warranty != null && warranty!.isNotEmpty,
      'warranty_details': warranty,
      
      // Timestamps
      'created_at': createAt?.toIso8601String(),
      'updated_at': updateAt?.toIso8601String(),
    };
  }
}
