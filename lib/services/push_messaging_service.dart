import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wolfera/services/notification_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // ملاحظة: على iOS عند الإغلاق التام، نظام iOS يعرض إشعار notification تلقائياً
  // أما رسائل data-only فقد لا تُعالَج هنا. على Android يعمل هذا المعالج في الخلفية.
  if (kDebugMode) {
    print('🔔 [BG] RemoteMessage: ${message.data}');
  }
}

class PushMessagingService {
  PushMessagingService._();

  static final _client = Supabase.instance.client;

  static Future<void> initialize() async {
    // تأكد من تهيئة Firebase
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }

    // معالج الرسائل في الخلفية
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // طلب الأذونات
    await _requestPermissions();

    // تقديم الإشعارات أثناء المقدمة على iOS
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // تهيئة الإشعارات المحلية
    await NotificationService.initializePlatformNotifications();

    // Foreground messages → أظهر إشعاراً محلياً
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final notification = message.notification;
      final title = notification?.title ?? message.data['title']?.toString() ?? 'إشعار';
      final body = notification?.body ?? message.data['body']?.toString() ?? '';
      final payload = message.data.isNotEmpty ? message.data.toString() : '{}';

      await NotificationService.showLocalNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: title,
        body: body,
        payload: payload,
      );
    });

    // إذا فُتح التطبيق من إشعار
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (kDebugMode) {
        print('🔔 Opened from notification: ${message.data}');
      }
      // TODO: توجيه المستخدم حسب نوع الإشعار (router)
    });

    // رسالة الإطلاق (إذا فُتح التطبيق من إشعار وهو مغلق تماماً)
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null && kDebugMode) {
      print('🔔 Initial message: ${initial.data}');
    }

    // حفظ/تحديث التوكن
    await _persistDeviceToken();

    // عند تحديث التوكن
    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      await _persistDeviceToken(tokenOverride: token);
    });
  }

  static Future<void> _requestPermissions() async {
    try {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      // Android 13+: اطلب إذن POST_NOTIFICATIONS عبر flutter_local_notifications
      try {
        final androidPlugin = FlutterLocalNotificationsPlugin()
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();
        await androidPlugin?.requestNotificationsPermission();
      } catch (_) {}
    } catch (_) {}
  }

  static Future<void> _persistDeviceToken({String? tokenOverride}) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return;

      final token = tokenOverride ?? await FirebaseMessaging.instance.getToken();
      if (token == null) return;

      final platform = Platform.isAndroid ? 'android' : (Platform.isIOS ? 'ios' : 'other');

      // جدول مقترح: user_devices(user_id text, token text pk/unique, platform text, updated_at timestamptz)
      await _client.from('user_devices').upsert({
        'user_id': user.id,
        'token': token,
        'platform': platform,
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'token');
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Failed to persist FCM token: $e');
      }
    }
  }
}
