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
    
    final userData = {
      'uid': user.id,
      'email': user.email,
      'displayName': user.userMetadata?['display_name'],
      'emailVerified': user.emailConfirmedAt != null,
      'photoURL': user.userMetadata?['avatar_url'],
      'phoneNumber': phoneNumber
    };
    return _preferences.setString(PrefsKey.user, jsonEncode(userData));
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
