// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CarModelImpl _$$CarModelImplFromJson(Map<String, dynamic> json) =>
    _$CarModelImpl(
      id: json['id'] as String?,
      userId: json['userId'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      year: (json['year'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      mileage: (json['mileage'] as num?)?.toInt(),
      transmission: json['transmission'] as String?,
      fuelType: json['fuelType'] as String?,
      bodyType: json['bodyType'] as String?,
      color: json['color'] as String?,
      engineCapacity: (json['engineCapacity'] as num?)?.toDouble(),
      cylinders: (json['cylinders'] as num?)?.toInt(),
      seats: (json['seats'] as num?)?.toInt(),
      doors: (json['doors'] as num?)?.toInt(),
      driveType: json['driveType'] as String?,
      condition: json['condition'] as String? ?? 'used',
      accidentsHistory: json['accidentsHistory'] as bool? ?? false,
      serviceHistory: json['serviceHistory'] as bool? ?? false,
      warranty: json['warranty'] as bool? ?? false,
      warrantyDetails: json['warrantyDetails'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      safetyFeatures: (json['safetyFeatures'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      interiorFeatures: (json['interiorFeatures'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      exteriorFeatures: (json['exteriorFeatures'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      mainImageUrl: json['mainImageUrl'] as String?,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      location: json['location'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      status: json['status'] as String? ?? 'active',
      viewsCount: (json['viewsCount'] as num?)?.toInt() ?? 0,
      favoritesCount: (json['favoritesCount'] as num?)?.toInt() ?? 0,
      isFeatured: json['isFeatured'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      soldAt: json['soldAt'] == null
          ? null
          : DateTime.parse(json['soldAt'] as String),
    );

Map<String, dynamic> _$$CarModelImplToJson(_$CarModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'brand': instance.brand,
      'model': instance.model,
      'year': instance.year,
      'price': instance.price,
      'currency': instance.currency,
      'mileage': instance.mileage,
      'transmission': instance.transmission,
      'fuelType': instance.fuelType,
      'bodyType': instance.bodyType,
      'color': instance.color,
      'engineCapacity': instance.engineCapacity,
      'cylinders': instance.cylinders,
      'seats': instance.seats,
      'doors': instance.doors,
      'driveType': instance.driveType,
      'condition': instance.condition,
      'accidentsHistory': instance.accidentsHistory,
      'serviceHistory': instance.serviceHistory,
      'warranty': instance.warranty,
      'warrantyDetails': instance.warrantyDetails,
      'title': instance.title,
      'description': instance.description,
      'safetyFeatures': instance.safetyFeatures,
      'interiorFeatures': instance.interiorFeatures,
      'exteriorFeatures': instance.exteriorFeatures,
      'mainImageUrl': instance.mainImageUrl,
      'imageUrls': instance.imageUrls,
      'location': instance.location,
      'city': instance.city,
      'country': instance.country,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'status': instance.status,
      'viewsCount': instance.viewsCount,
      'favoritesCount': instance.favoritesCount,
      'isFeatured': instance.isFeatured,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'soldAt': instance.soldAt?.toIso8601String(),
    };
