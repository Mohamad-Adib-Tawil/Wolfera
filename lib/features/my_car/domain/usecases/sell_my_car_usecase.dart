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

  SellMyCarParams({
    required this.userId,
    required this.location,
    required this.status,
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
  });

  Map<String, dynamic> toMapWithUrls(List<String> uploadedUrls) {
    // Generate title from car details
    final titleParts = [carYear, carMaker, carModel]
        .where((e) => e.isNotEmpty)
        .join(' ');
    final title = titleParts.isNotEmpty ? titleParts : 'Car for Sale';
    
    return {
      // Required fields
      'user_id': userId,
      'title': title,
      
      // Core car details
      'brand': carMaker,
      'model': carModel,
      'year': int.tryParse(carYear),
      'price': num.tryParse(carPrice),
      'currency': 'USD',
      'mileage': int.tryParse(carMileage),
      'transmission': carTransmission,
      'fuel_type': carFuelType,
      'body_type': carVehicleType,
      'color': carColor,
      'engine_capacity': num.tryParse(carEngine),
      'cylinders': int.tryParse(carCylinders),
      'seats': int.tryParse(carSeats),
      'condition': carCondition,
      
      // Location
      'location': carLocation,
      'city': carLocation,
      'country': location,
      
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
      
      // Warranty
      'warranty': warranty != null && warranty!.isNotEmpty,
      'warranty_details': warranty,
      
      // Timestamps
      'created_at': createAt?.toIso8601String(),
      'updated_at': updateAt?.toIso8601String(),
    };
  }
}
