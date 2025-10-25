import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String fullName,
    required String email,
    String? phoneNumber,
    String? avatarUrl,
    String? location,
    String? city,
    String? country,
    @Default(false) bool isDealer,
    String? dealerName,
    String? dealerLicense,
    @Default(0.0) double rating,
    @Default(0) int totalReviews,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  // Helper method to create from Supabase Auth User
  factory UserModel.fromSupabaseUser(User user, {Map<String, dynamic>? additionalData}) {
    return UserModel(
      id: user.id,
      email: user.email ?? '',
      fullName: user.userMetadata?['full_name'] ?? 
                additionalData?['full_name'] ?? 
                user.email?.split('@').first ?? 'User',
      phoneNumber: additionalData?['phone_number'],
      avatarUrl: user.userMetadata?['avatar_url'] ?? additionalData?['avatar_url'],
      location: additionalData?['location'],
      city: additionalData?['city'],
      country: additionalData?['country'],
      isDealer: additionalData?['is_dealer'] ?? false,
      dealerName: additionalData?['dealer_name'],
      dealerLicense: additionalData?['dealer_license'],
      rating: (additionalData?['rating'] ?? 0.0).toDouble(),
      totalReviews: additionalData?['total_reviews'] ?? 0,
      createdAt: DateTime.tryParse(additionalData?['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(additionalData?['updated_at'] ?? '') ?? DateTime.now(),
    );
  }
}
