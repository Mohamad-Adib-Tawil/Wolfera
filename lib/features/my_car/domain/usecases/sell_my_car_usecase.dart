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
    return {
      'user_id': userId,
      'location': location,
      'status': status,
      'car_maker': carMaker,
      'car_model': carModel,
      'car_engine': carEngine,
      'car_year': carYear,
      'car_transmission': carTransmission,
      'car_mileage': carMileage,
      'car_fuel_type': carFuelType,
      'car_trim': carTrim,
      'car_cylinders': carCylinders,
      'car_seats': carSeats,
      'car_paint_parts': carPaintParts,
      'car_condition': carCondition,
      'car_plate': carPlate,
      'car_color': carColor,
      'car_seat_material': carSeatMaterial,
      'car_wheels': carWheels,
      'car_vehicle_type': carVehicleType,
      'car_interior_color': carInteriorColor,
      'car_exterior_color': carExteriorColor,
      'car_price': carPrice,
      'car_location': carLocation,
      'car_images': uploadedUrls,
      'warranty': warranty,
      'created_at': createAt?.toIso8601String(),
      'updated_at': updateAt?.toIso8601String(),
    };
  }
}
