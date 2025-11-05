import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // Handle notification tap
  if (kDebugMode) {
    print('Notification tapped: ${notificationResponse.payload}');
  }
}

class NotificationService {
  NotificationService();

  static final _localNotifications = FlutterLocalNotificationsPlugin();
  static final _client = Supabase.instance.client;
  static void Function(String? payload)? onTap;

  static Future<void> initializePlatformNotifications() async {
    // Use a valid Android resource for the small icon. The default launcher icon
    // exists in all Flutter templates under @mipmap/ic_launcher.
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_stat_notify');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
            requestSoundPermission: true,
            requestBadgePermission: true,
            requestAlertPermission: true,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(
      initializationSettings,
      // MUST be a top-level/static function for background handling
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      // Foreground tap handler can be a closure; delegate to onTap
      onDidReceiveNotificationResponse: (resp) {
        onTap?.call(resp.payload);
      },
    );

    // Note: If you need Android 13+ runtime notification permission,
    // request it via the permission_handler package at app level.
  }

  static void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    if (kDebugMode) {
      print('id $id');
    }
  }

  static Future<NotificationDetails> _notificationDetails() async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'wolfera-Cars',
      'Wolfera Cars Notification',
      groupKey: 'com.wolfera.wolfera',
      channelDescription: 'for receive notification',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      icon: '@drawable/ic_stat_notify',
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/launcher_icon'),
    );

    DarwinNotificationDetails iosNotificationDetails =
        const DarwinNotificationDetails(
      presentBadge: true,
      presentSound: true,
    );

    final details = await _localNotifications.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {}
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);

    return platformChannelSpecifics;
  }

  static Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    final platformChannelSpecifics = await _notificationDetails();
    await _localNotifications.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }
  
  // إرسال إشعار لمستخدم آخر عبر Supabase
  static Future<bool> sendNotificationToUser({
    required String userId,
    required String title,
    required String body,
    required String type,
    String? senderId,
    Map<String, dynamic>? data,
  }) async {
    try {
      await _client.from('notifications').insert({
        'user_id': userId,
        'sender_id': senderId ?? _client.auth.currentUser?.id,
        'title': title,
        'body': body,
        'type': type,
        'data': data ?? {},
        'read_at': null,
      });

      // استدعاء دالة Edge Function لإرسال Push عبر FCM
      try {
        final payload = {
          'user_id': userId,
          'title': title,
          'body': body,
          'data': (data ?? {})..addAll({'type': type}),
        };
        await _client.functions.invoke('push', body: payload);
      } catch (e) {
        if (kDebugMode) {
          print('Edge Function push invoke failed: $e');
        }
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error sending notification: $e');
      }
      return false;
    }
  }
  
  // إرسال إشعار رسالة جديدة
  static Future<void> sendNewMessageNotification({
    required String recipientId,
    required String senderName,
    required String messageText,
    required String conversationId,
  }) async {
    await sendNotificationToUser(
      userId: recipientId,
      title: 'رسالة جديدة من $senderName',
      body: messageText,
      type: 'new_message',
      data: {
        'conversation_id': conversationId,
        'action': 'open_chat',
      },
    );
  }
  
  // إرسال إشعار عرض سعر
  static Future<void> sendOfferNotification({
    required String recipientId,
    required String senderName,
    required String carTitle,
    required String offerId,
  }) async {
    await sendNotificationToUser(
      userId: recipientId,
      title: 'عرض جديد على $carTitle',
      body: '$senderName قدم عرضاً على سيارتك',
      type: 'new_offer',
      data: {
        'offer_id': offerId,
        'action': 'view_offer',
      },
    );
  }
  
  // إرسال إشعار إعجاب بسيارة
  static Future<void> sendLikeNotification({
    required String carOwnerId,
    required String likerName,
    required String carTitle,
    required String carId,
  }) async {
    await sendNotificationToUser(
      userId: carOwnerId,
      title: 'إعجاب جديد',
      body: '$likerName أعجب بسيارتك $carTitle',
      type: 'car_like',
      data: {
        'car_id': carId,
        'action': 'view_car',
      },
    );
  }
  
  // إرسال إشعار تعليق
  static Future<void> sendCommentNotification({
    required String recipientId,
    required String commenterName,
    required String carTitle,
    required String comment,
    required String carId,
  }) async {
    await sendNotificationToUser(
      userId: recipientId,
      title: 'تعليق جديد على $carTitle',
      body: '$commenterName: $comment',
      type: 'car_comment',
      data: {
        'car_id': carId,
        'action': 'view_comments',
      },
    );
  }
}
