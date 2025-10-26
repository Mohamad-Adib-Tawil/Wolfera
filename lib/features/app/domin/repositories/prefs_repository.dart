import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:wolfera/features/auth/data/models/local_user.dart';

abstract class PrefsRepository {
  String? get token;
  Future<bool> setToken(String token);
  ThemeMode get getTheme;
  Future<bool> clearLocal();
  bool get registeredUser;
  LocalUser? get user;
  Future<bool> setUser(User user, String phoneNumber);
  // Selected city persistence
  String? get selectedCity;
  Future<bool> setSelectedCity(String city);

  // Address selections (new)
  String? get selectedCountryCode; // e.g., 'AE', 'SY', 'DE', 'WW'
  Future<bool> setSelectedCountryCode(String? code);

  String? get selectedRegionOrCity; // e.g., 'Dubai', 'Damascus'
  Future<bool> setSelectedRegionOrCity(String? value);

  bool get isWorldwide; // true => Worldwide mode
  Future<bool> setWorldwide(bool value);
}
