import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wolfera/features/auth/data/models/local_user.dart';

import '../../../../common/constants/prefs_key.dart';
import '../../domin/repositories/prefs_repository.dart';

@Injectable(as: PrefsRepository)
class PrefsRepositoryImpl extends PrefsRepository {
  PrefsRepositoryImpl(this._preferences);

  final SharedPreferences _preferences;

  @override
  Future<bool> setToken(String token) =>
      _preferences.setString(PrefsKey.token, token);

  @override
  String? get token => _preferences.getString(PrefsKey.token);

  @override
  Future<bool> clearLocal() async {
    return (await Future.wait([
      _preferences.remove(PrefsKey.token),
      _preferences.remove(PrefsKey.user),
      _preferences.clear(),
    ]))
        .reduce((value, element) => value && element);
  }

  @override
  bool get registeredUser => token != null;

  @override
  Future<bool> setUser(User user, String phoneNumber) async {
    // For Supabase, we can use the access token
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      await setToken(session.accessToken);
    }
    
    // Get display name from multiple sources (priority order)
    String? displayName = user.userMetadata?['display_name'] ?? 
                         user.userMetadata?['full_name'] ?? 
                         user.email?.split('@').first;
    
    // Get avatar URL from multiple sources
    String? photoURL = user.userMetadata?['avatar_url'] ?? 
                      user.userMetadata?['photo_url'];
    
    final userData = {
      'uid': user.id,
      'email': user.email,
      'displayName': displayName,
      'emailVerified': user.emailConfirmedAt != null,
      'photoURL': photoURL,
      'phoneNumber': phoneNumber
    };
    
    debugPrint('💾 Saving user to prefs: $userData');
    return _preferences.setString(PrefsKey.user, jsonEncode(userData));
  }

  @override
  String? get selectedCity => _preferences.getString(PrefsKey.city);

  @override
  Future<bool> setSelectedCity(String city) async {
    return _preferences.setString(PrefsKey.city, city);
  }

  @override
  LocalUser? get user {
    final currentUser = _preferences.getString(PrefsKey.user);
    if (currentUser == null) {
      return null;
    }

    final userData = jsonDecode(currentUser);
    return LocalUser.fromJson(userData);
  }

  @override
  ThemeMode get getTheme => throw UnimplementedError();
}
