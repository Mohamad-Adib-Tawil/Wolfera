import 'package:flutter/foundation.dart';
import 'package:wolfera/services/supabase_service.dart';
import 'package:wolfera/services/notification_service.dart';

/// مساعد لتشخيص مشاكل الإشعارات
class NotificationDebugHelper {
  
  /// فحص شامل لحالة الإشعارات لمستخدم معين
  static Future<void> debugUserNotifications(String userId) async {
    if (!kDebugMode) return;
    
    print('\n🔍 ========== NOTIFICATION DEBUG START ==========');
    print('👤 User ID: $userId');
    
    try {
      // 1. فحص المفضلات
      await _checkUserFavorites(userId);
      
      // 2. فحص الإشعارات المرسلة
      await _checkUserNotifications(userId);
      
      // 3. فحص إعدادات المستخدم
      await _checkUserSettings(userId);
      
    } catch (e) {
      print('❌ Error during debug: $e');
    }
    
    print('🔍 ========== NOTIFICATION DEBUG END ==========\n');
  }
  
  /// فحص السيارات المضافة للمفضلة
  static Future<void> _checkUserFavorites(String userId) async {
    print('\n📋 Checking user favorites...');
    
    try {
      final favorites = await SupabaseService.client
          .from('favorites')
          .select('''
            *,
            car:car_id (
              id,
              title,
              user_id,
              rental_price_per_day,
              rental_price_per_week,
              rental_price_per_month,
              price
            )
          ''')
          .eq('user_id', userId);
      
      print('   Found ${favorites.length} favorite cars:');
      
      for (final favorite in favorites) {
        final car = favorite['car'];
        if (car != null) {
          print('   🚗 Car: ${car['title']} (ID: ${car['id']})');
          print('      Owner: ${car['user_id']}');
          print('      Sale Price: ${car['price']}');
          print('      Daily Rental: ${car['rental_price_per_day']}');
          print('      Weekly Rental: ${car['rental_price_per_week']}');
          print('      Monthly Rental: ${car['rental_price_per_month']}');
        }
      }
      
      if (favorites.isEmpty) {
        print('   ⚠️ No favorite cars found for this user');
      }
      
    } catch (e) {
      print('   ❌ Error checking favorites: $e');
    }
  }
  
  /// فحص الإشعارات المرسلة للمستخدم
  static Future<void> _checkUserNotifications(String userId) async {
    print('\n🔔 Checking user notifications...');
    
    try {
      final notifications = await SupabaseService.client
          .from('notifications')
          .select('*')
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(10);
      
      print('   Found ${notifications.length} recent notifications:');
      
      for (final notification in notifications) {
        print('   📨 ${notification['type']}: ${notification['title']}');
        print('      Body: ${notification['body']}');
        print('      Created: ${notification['created_at']}');
        print('      Read: ${notification['read_at'] != null ? "✅" : "❌"}');
        print('      Data: ${notification['data']}');
        print('');
      }
      
      // فحص إشعارات تغيير السعر تحديداً
      final priceChangeNotifications = await SupabaseService.client
          .from('notifications')
          .select('*')
          .eq('user_id', userId)
          .eq('type', 'price_change')
          .order('created_at', ascending: false);
      
      print('   Price change notifications: ${priceChangeNotifications.length}');
      
    } catch (e) {
      print('   ❌ Error checking notifications: $e');
    }
  }
  
  /// فحص إعدادات المستخدم
  static Future<void> _checkUserSettings(String userId) async {
    print('\n⚙️ Checking user settings...');
    
    try {
      final user = await SupabaseService.client
          .from('users')
          .select('*')
          .eq('id', userId)
          .maybeSingle();
      
      if (user != null) {
        print('   User found:');
        print('   - Name: ${user['full_name']}');
        print('   - Language: ${user['preferred_language']}');
        print('   - FCM Token: ${user['fcm_token'] != null ? "✅ Present" : "❌ Missing"}');
      } else {
        print('   ❌ User not found in database');
      }
      
    } catch (e) {
      print('   ❌ Error checking user settings: $e');
    }
  }
  
  /// اختبار إرسال إشعار تجريبي
  static Future<void> testNotificationForUser(String userId) async {
    if (!kDebugMode) return;
    
    print('\n🧪 Testing notification for user: $userId');
    
    try {
      final success = await NotificationService.sendNotificationToUser(
        userId: userId,
        title: 'Test Notification',
        body: 'This is a test notification to check if notifications are working',
        type: 'test',
        data: {
          'test': true,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      
      print('   Test notification result: ${success ? "✅ Success" : "❌ Failed"}');
      
    } catch (e) {
      print('   ❌ Error sending test notification: $e');
    }
  }
  
  /// فحص شامل لسيارة معينة ومن أضافها للمفضلة
  static Future<void> debugCarFavorites(String carId) async {
    if (!kDebugMode) return;
    
    print('\n🚗 ========== CAR FAVORITES DEBUG ==========');
    print('Car ID: $carId');
    
    try {
      // جلب بيانات السيارة
      final car = await SupabaseService.client
          .from('cars')
          .select('*')
          .eq('id', carId)
          .maybeSingle();
      
      if (car == null) {
        print('❌ Car not found');
        return;
      }
      
      print('🚗 Car: ${car['title']}');
      print('   Owner: ${car['user_id']}');
      print('   Prices:');
      print('     - Sale: ${car['price']}');
      print('     - Daily: ${car['rental_price_per_day']}');
      print('     - Weekly: ${car['rental_price_per_week']}');
      print('     - Monthly: ${car['rental_price_per_month']}');
      
      // جلب المستخدمين الذين أضافوها للمفضلة
      final favorites = await SupabaseService.client
          .from('favorites')
          .select('''
            *,
            user:user_id (
              id,
              full_name,
              fcm_token
            )
          ''')
          .eq('car_id', carId);
      
      print('\n👥 Users who favorited this car (${favorites.length}):');
      
      for (final favorite in favorites) {
        final user = favorite['user'];
        if (user != null) {
          print('   - ${user['full_name']} (${user['id']})');
          print('     FCM Token: ${user['fcm_token'] != null ? "✅" : "❌"}');
        }
      }
      
    } catch (e) {
      print('❌ Error: $e');
    }
    
    print('🚗 ========== CAR FAVORITES DEBUG END ==========\n');
  }
}
