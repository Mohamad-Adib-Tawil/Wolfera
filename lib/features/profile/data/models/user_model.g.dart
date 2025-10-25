// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      location: json['location'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      isDealer: json['isDealer'] as bool? ?? false,
      dealerName: json['dealerName'] as String?,
      dealerLicense: json['dealerLicense'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: (json['totalReviews'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'avatarUrl': instance.avatarUrl,
      'location': instance.location,
      'city': instance.city,
      'country': instance.country,
      'isDealer': instance.isDealer,
      'dealerName': instance.dealerName,
      'dealerLicense': instance.dealerLicense,
      'rating': instance.rating,
      'totalReviews': instance.totalReviews,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
