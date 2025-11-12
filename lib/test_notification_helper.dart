import 'package:flutter/foundation.dart';
import 'package:wolfera/services/supabase_service.dart';
import 'package:wolfera/services/notification_service.dart';

/// مساعد لاختبار الإشعارات مباشرة
class TestNotificationHelper {
  
  /// اختبار إشعار تغيير السعر لسيارة معينة
  static Future<void> testPriceChangeForCar(String carId) async {
    if (!kDebugMode) return;
    
    print('\n🧪 ========== TESTING PRICE CHANGE NOTIFICATION ==========');
    print('Car ID: $carId');
    
    try {
      // 1. جلب بيانات السيارة
      final car = await SupabaseService.client
          .from('cars')
          .select('*')
          .eq('id', carId)
          .maybeSingle();
      
      if (car == null) {
        print('❌ Car not found');
        return;
      }
      
      print('🚗 Car found: ${car['title']}');
      print('   Current daily price: ${car['rental_price_per_day']}');
      
      // 2. جلب المستخدمين الذين أضافوها للمفضلة
      final favorites = await SupabaseService.client
          .from('favorites')
          .select('user_id')
          .eq('car_id', carId);
      
      print('👥 Found ${favorites.length} users who favorited this car');
      
      if (favorites.isEmpty) {
        print('⚠️ No users have favorited this car. Add it to favorites first!');
        return;
      }
      
      // 3. إرسال إشعار تجريبي
      print('📤 Sending test price change notification...');
      
      await NotificationService.sendPriceChangeNotification(
        carId: carId,
        carTitle: car['title'] ?? 'Test Car',
        oldPrice: '100',
        newPrice: '150',
      );
      
      print('✅ Test notification sent successfully!');
      
    } catch (e) {
      print('❌ Error during test: $e');
    }
    
    print('🧪 ========== TEST COMPLETED ==========\n');
  }
  
  /// إضافة السيارة للمفضلة للمستخدم الحالي (للاختبار)
  static Future<void> addCarToFavorites(String carId) async {
    try {
      final user = SupabaseService.currentUser;
      if (user == null) {
        print('❌ No user logged in');
        return;
      }
      
      print('➕ Adding car $carId to favorites for user ${user.id}');
      
      await SupabaseService.client.from('favorites').upsert({
        'user_id': user.id,
        'car_id': carId,
        'created_at': DateTime.now().toIso8601String(),
      });
      
      print('✅ Car added to favorites successfully');
      
    } catch (e) {
      print('❌ Error adding to favorites: $e');
    }
  }
  
  /// محاكاة تغيير سعر الإيجار اليومي
  static Future<void> simulatePriceChange(String carId, String newPrice) async {
    try {
      print('💰 Simulating price change for car: $carId');
      print('   New daily price: $newPrice');
      
      // استخدام updateCar لضمان إرسال الإشعارات
      await SupabaseService.updateCar(carId, {
        'rental_price_per_day': double.tryParse(newPrice),
        'updated_at': DateTime.now().toIso8601String(),
      });
      
      print('✅ Price updated successfully');
      
    } catch (e) {
      print('❌ Error updating price: $e');
    }
  }
  
  /// فحص حالة FCM Token للمستخدم الحالي
  static Future<void> checkFCMTokenStatus() async {
    try {
      final user = SupabaseService.currentUser;
      if (user == null) {
        print('❌ No user logged in');
        return;
      }
      
      print('\n📱 ========== FCM TOKEN STATUS ==========');
      print('User ID: ${user.id}');
      
      // فحص جدول users
      final userData = await SupabaseService.client
          .from('users')
          .select('fcm_token')
          .eq('id', user.id)
          .maybeSingle();
      
      if (userData != null) {
        final token = userData['fcm_token'];
        print('Users table FCM token: ${token != null ? "✅ Present" : "❌ Missing"}');
        if (token != null) {
          print('Token preview: ${token.substring(0, 20)}...');
        }
      }
      
      // فحص جدول user_devices
      final deviceData = await SupabaseService.client
          .from('user_devices')
          .select('token, platform, updated_at')
          .eq('user_id', user.id);
      
      print('User devices: ${deviceData.length} entries');
      for (final device in deviceData) {
        print('  - Platform: ${device['platform']}');
        print('    Token: ${device['token']?.substring(0, 20)}...');
        print('    Updated: ${device['updated_at']}');
      }
      
      print('📱 ========== FCM TOKEN CHECK END ==========\n');
      
    } catch (e) {
      print('❌ Error checking FCM token: $e');
    }
  }
  
  /// اختبار شامل للإشعارات
  static Future<void> fullNotificationTest(String carId) async {
    print('\n🔬 ========== FULL NOTIFICATION TEST ==========');
    
    // 1. فحص FCM Token
    await checkFCMTokenStatus();
    
    // 2. إضافة السيارة للمفضلة
    await addCarToFavorites(carId);
    
    // 3. اختبار إشعار تغيير السعر
    await testPriceChangeForCar(carId);
    
    // 4. محاكاة تغيير سعر حقيقي
    final newPrice = (DateTime.now().millisecondsSinceEpoch % 1000 + 100).toString();
    await simulatePriceChange(carId, newPrice);
    
    print('🔬 ========== FULL TEST COMPLETED ==========\n');
  }
}
