import 'package:flutter/foundation.dart';
import 'package:wolfera/services/supabase_service.dart';

/// مساعد لإصلاح مشاكل المفضلة
class FavoritesFixHelper {
  
  /// إضافة السيارة للمفضلة مباشرة في قاعدة البيانات
  static Future<void> addCarToFavoritesDirect() async {
    const carId = '165f0984-46d5-4f74-a44f-239d6e511c3e';
    const userId = '9d8f5abd-5e8d-48c2-8878-c6a1035ce087'; // الجهاز الأول
    
    try {
      print('🔧 DIRECT FIX: Adding car to favorites');
      print('   Car ID: $carId');
      print('   User ID: $userId');
      
      // إضافة مباشرة لقاعدة البيانات
      await SupabaseService.client.from('favorites').insert({
        'user_id': userId,
        'car_id': carId,
        'created_at': DateTime.now().toIso8601String(),
      });
      
      print('✅ Car added to favorites successfully!');
      
      // التحقق من الإضافة
      await checkFavoritesStatus();
      
    } catch (e) {
      print('❌ Error adding to favorites: $e');
    }
  }
  
  /// فحص حالة المفضلة للسيارة
  static Future<void> checkFavoritesStatus() async {
    const carId = '165f0984-46d5-4f74-a44f-239d6e511c3e';
    
    try {
      print('\n🔍 Checking favorites status...');
      
      final favorites = await SupabaseService.client
          .from('favorites')
          .select('''
            *,
            user:user_id (
              id,
              full_name
            )
          ''')
          .eq('car_id', carId);
      
      print('📋 Found ${favorites.length} users who favorited this car:');
      
      if (favorites.isEmpty) {
        print('⚠️ No users have favorited this car yet!');
      } else {
        for (final fav in favorites) {
          final user = fav['user'];
          print('   - ${user?['full_name'] ?? 'Unknown'} (${fav['user_id']})');
          print('     Added: ${fav['created_at']}');
        }
      }
      
    } catch (e) {
      print('❌ Error checking favorites: $e');
    }
  }
  
  /// إزالة جميع المفضلات للسيارة (للتنظيف)
  static Future<void> clearAllFavoritesForCar() async {
    const carId = '165f0984-46d5-4f74-a44f-239d6e511c3e';
    
    try {
      print('🧹 Clearing all favorites for car: $carId');
      
      await SupabaseService.client
          .from('favorites')
          .delete()
          .eq('car_id', carId);
      
      print('✅ All favorites cleared');
      
    } catch (e) {
      print('❌ Error clearing favorites: $e');
    }
  }
  
  /// اختبار شامل للمفضلة
  static Future<void> fullFavoritesTest() async {
    print('\n🧪 ========== FULL FAVORITES TEST ==========');
    
    // 1. فحص الحالة الحالية
    await checkFavoritesStatus();
    
    // 2. تنظيف المفضلات
    await clearAllFavoritesForCar();
    
    // 3. إضافة السيارة للمفضلة
    await addCarToFavoritesDirect();
    
    // 4. فحص النتيجة النهائية
    await checkFavoritesStatus();
    
    print('🧪 ========== FAVORITES TEST COMPLETED ==========\n');
  }
}
