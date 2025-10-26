import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

// مستودع بسيط لتخزين/قراءة المفضلات لكل مستخدم عبر SharedPreferences
class FavoriteRepository {
  FavoriteRepository(this._prefs);

  final SharedPreferences _prefs;

  String _keyForUser(String userId) => 'favorites_$userId';

  Future<List<Map<String, dynamic>>> loadFavorites(String userId) async {
    final raw = _prefs.getString(_keyForUser(userId));
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw);
      if (list is List) {
        return list
            .whereType<Map>()
            .map((e) => e.map((k, v) => MapEntry(k.toString(), v)))
            .cast<Map<String, dynamic>>()
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<void> saveFavorites(
    String userId,
    List<Map<String, dynamic>> cars,
  ) async {
    final str = jsonEncode(cars);
    await _prefs.setString(_keyForUser(userId), str);
  }
}
