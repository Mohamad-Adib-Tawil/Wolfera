import 'package:wolfera/services/notification_service.dart';
import 'package:wolfera/services/supabase_service.dart';

/// مساعد لإدارة إشعارات تغيير الأسعار
class PriceChangeHelper {
  
  /// إرسال إشعار تغيير السعر للمستخدمين الذين أضافوا السيارة للمفضلة
  /// يمكن استخدام هذه الدالة من أي مكان في التطبيق
  static Future<void> notifyPriceChange({
    required String carId,
    required String carTitle,
    required String oldPrice,
    required String newPrice,
  }) async {
    await NotificationService.sendPriceChangeNotification(
      carId: carId,
      carTitle: carTitle,
      oldPrice: oldPrice,
      newPrice: newPrice,
    );
  }

  /// تحديث سعر السيارة مع إشعار المستخدمين تلقائياً
  static Future<void> updateCarPriceWithNotification({
    required String carId,
    required String newPrice,
    Map<String, dynamic>? additionalData,
  }) async {
    // جلب بيانات السيارة الحالية
    final currentCar = await SupabaseService.client
        .from('cars')
        .select('rental_price, title')
        .eq('id', carId)
        .single();
    
    final oldPrice = currentCar['rental_price']?.toString();
    final carTitle = currentCar['title']?.toString() ?? 'Unknown Car';
    
    // تحضير البيانات للتحديث
    final updateData = <String, dynamic>{
      'rental_price': newPrice,
      ...?additionalData,
    };
    
    // تحديث السيارة (سيتم إرسال الإشعار تلقائياً من خلال updateCar)
    await SupabaseService.updateCar(carId, updateData);
  }

  /// التحقق من وجود مستخدمين أضافوا السيارة للمفضلة
  static Future<List<String>> getFavoriteUserIds(String carId) async {
    try {
      final favoriteUsers = await SupabaseService.client
          .from('favorites')
          .select('user_id')
          .eq('car_id', carId);

      return favoriteUsers
          .map((favorite) => favorite['user_id'] as String)
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// إحصائيات المفضلة للسيارة
  static Future<int> getFavoriteCount(String carId) async {
    try {
      final favoriteUsers = await getFavoriteUserIds(carId);
      return favoriteUsers.length;
    } catch (e) {
      return 0;
    }
  }
}
