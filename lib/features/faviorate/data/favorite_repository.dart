import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wolfera/services/supabase_service.dart';

// مستودع محسّن لإدارة المفضلات مع دعم Supabase + SharedPreferences
class FavoriteRepository {
  FavoriteRepository(this._prefs);

  final SharedPreferences _prefs;
  final _client = SupabaseService.client;

  String _keyForUser(String userId) => 'favorites_$userId';
  String _lastSyncKey(String userId) => 'favorites_last_sync_$userId';

  // ============ SharedPreferences (Cache المحلي) ============
  
  Future<List<Map<String, dynamic>>> loadFavoritesFromCache(String userId) async {
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

  Future<void> saveFavoritesToCache(
    String userId,
    List<Map<String, dynamic>> cars,
  ) async {
    final str = jsonEncode(cars);
    await _prefs.setString(_keyForUser(userId), str);
    await _prefs.setString(_lastSyncKey(userId), DateTime.now().toIso8601String());
  }

  Future<void> clearCache(String userId) async {
    await _prefs.remove(_keyForUser(userId));
    await _prefs.remove(_lastSyncKey(userId));
  }

  // ============ Supabase (قاعدة البيانات) ============

  /// جلب المفضلات من Supabase مع بيانات السيارات الكاملة
  Future<List<Map<String, dynamic>>> loadFavoritesFromSupabase(String userId) async {
    try {
      final response = await _client
          .from('favorites')
          .select('''
            *,
            car:car_id (
              *,
              owner:user_id (
                id,
                full_name,
                avatar_url,
                city,
                country
              )
            )
          ''')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final favorites = (response as List).cast<Map<String, dynamic>>();
      
      // استخراج بيانات السيارات فقط
      final cars = favorites
          .where((f) => f['car'] != null)
          .map((f) => f['car'] as Map<String, dynamic>)
          .toList();
      
      return cars;
    } catch (e) {
      // Error loading from Supabase: $e
      return [];
    }
  }

  /// إضافة سيارة للمفضلة في Supabase
  Future<bool> addToSupabase(String userId, String carId) async {
    try {
      await _client.from('favorites').insert({
        'user_id': userId,
        'car_id': carId,
        'created_at': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      // Error adding to Supabase: $e
      return false;
    }
  }

  /// إزالة سيارة من المفضلة في Supabase
  Future<bool> removeFromSupabase(String userId, String carId) async {
    try {
      await _client
          .from('favorites')
          .delete()
          .eq('user_id', userId)
          .eq('car_id', carId);
      return true;
    } catch (e) {
      // Error removing from Supabase: $e
      return false;
    }
  }

  /// التحقق من حالة المفضلة في Supabase
  Future<bool> checkIsFavoriteInSupabase(String userId, String carId) async {
    try {
      final response = await _client
          .from('favorites')
          .select('id')
          .eq('user_id', userId)
          .eq('car_id', carId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }

  // ============ استراتيجية هجينة (Hybrid Strategy) ============

  /// تحميل المفضلات: محاولة من Supabase أولاً، ثم Cache
  Future<List<Map<String, dynamic>>> loadFavorites(String userId) async {
    try {
      // محاولة جلب من Supabase
      final supabaseFavorites = await loadFavoritesFromSupabase(userId);
      
      if (supabaseFavorites.isNotEmpty) {
        // حفظ في Cache للاستخدام السريع لاحقاً
        await saveFavoritesToCache(userId, supabaseFavorites);
        return supabaseFavorites;
      }
    } catch (e) {
      // في حالة فشل Supabase، استخدم Cache
    }
    
    // الرجوع إلى Cache المحلي
    return await loadFavoritesFromCache(userId);
  }

  /// حفظ المفضلات: في كلا المكانين
  Future<void> saveFavorites(
    String userId,
    List<Map<String, dynamic>> cars,
  ) async {
    // حفظ في Cache فوراً
    await saveFavoritesToCache(userId, cars);
    
    // مزامنة مع Supabase في الخلفية (لا ننتظر)
    _syncToSupabase(userId, cars).catchError((_) {
      // Silent fail - Cache موجود على الأقل
    });
  }

  /// مزامنة Cache مع Supabase
  Future<void> _syncToSupabase(String userId, List<Map<String, dynamic>> cars) async {
    try {
      // جلب المفضلات الحالية من Supabase
      final supabaseFavorites = await loadFavoritesFromSupabase(userId);
      final supabaseIds = supabaseFavorites.map((c) => c['id']?.toString()).toSet();
      final cacheIds = cars.map((c) => c['id']?.toString()).toSet();

      // إضافة السيارات الجديدة
      for (final car in cars) {
        final carId = car['id']?.toString();
        if (carId != null && !supabaseIds.contains(carId)) {
          await addToSupabase(userId, carId);
        }
      }

      // إزالة السيارات المحذوفة
      for (final favorite in supabaseFavorites) {
        final carId = favorite['id']?.toString();
        if (carId != null && !cacheIds.contains(carId)) {
          await removeFromSupabase(userId, carId);
        }
      }
    } catch (e) {
      // Sync failed, will retry next time
    }
  }
}
