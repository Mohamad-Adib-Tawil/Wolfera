import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'car_model.freezed.dart';
part 'car_model.g.dart';

@freezed
class CarModel with _$CarModel {
  const factory CarModel({
    String? id,
    required String userId,
    
    // Basic Info
    required String brand,
    required String model,
    required int year,
    required double price,
    @Default('USD') String currency,
    
    // Specifications
    int? mileage,
    String? transmission, // manual, automatic, cvt, dct
    String? fuelType, // petrol, diesel, electric, hybrid
    String? bodyType,
    String? color,
    double? engineCapacity,
    int? cylinders,
    int? seats,
    int? doors,
    String? driveType, // fwd, rwd, awd, 4wd
    
    // Condition
    @Default('used') String condition, // new, used, certified
    @Default(false) bool accidentsHistory,
    @Default(false) bool serviceHistory,
    @Default(false) bool warranty,
    String? warrantyDetails,
    
    // Description
    required String title,
    String? description,
    
    // Features (JSON arrays in database)
    @Default([]) List<String> safetyFeatures,
    @Default([]) List<String> interiorFeatures,
    @Default([]) List<String> exteriorFeatures,
    
    // Images
    String? mainImageUrl,
    @Default([]) List<String> imageUrls,
    
    // Location
    String? location,
    String? city,
    String? country,
    double? latitude,
    double? longitude,
    
    // Status
    @Default('active') String status, // active, sold, pending, inactive
    @Default(0) int viewsCount,
    @Default(0) int favoritesCount,
    @Default(false) bool isFeatured,
    
    // Timestamps
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? soldAt,
  }) = _CarModel;

  factory CarModel.fromJson(Map<String, dynamic> json) =>
      _$CarModelFromJson(json);
  
  const CarModel._();
  
  // Helper methods
  String get fullTitle => '$year $brand $model';
  
  String get priceFormatted {
    final formatter = NumberFormat.currency(
      symbol: currency == 'USD' ? '\$' : currency,
      decimalDigits: 0,
    );
    return formatter.format(price);
  }
  
  String get mileageFormatted {
    if (mileage == null) return 'N/A';
    final formatter = NumberFormat('#,###');
    return '${formatter.format(mileage)} km';
  }
  
  bool get isNew => condition == 'new';
  bool get isActive => status == 'active';
  bool get isSold => status == 'sold';
  
  // Create a copy for upload (without id and timestamps)
  Map<String, dynamic> toUploadJson() {
    final json = toJson();
    json.remove('id');
    json.remove('created_at');
    json.remove('updated_at');
    json['user_id'] = userId;
    
    // Convert lists to JSONB format for Supabase
    json['safety_features'] = safetyFeatures;
    json['interior_features'] = interiorFeatures;
    json['exterior_features'] = exteriorFeatures;
    json['image_urls'] = imageUrls;
    
    return json;
  }
}
