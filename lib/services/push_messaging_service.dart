import 'dart:io';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wolfera/services/notification_service.dart';
import 'package:wolfera/services/chat_route_tracker.dart';
import 'package:wolfera/core/config/routing/router.dart';

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
    var firebaseReady = true;
    if (Firebase.apps.isEmpty) {
      try {
        await Firebase.initializeApp();
      } catch (e, st) {
        if (kDebugMode) {
          print('⚠️ Firebase.initializeApp failed: $e');
          print(st);
        }
        firebaseReady = false;
      }
    }
    if (!firebaseReady) {
      if (kDebugMode) {
        print('⚠️ Skipping FCM setup because Firebase is not configured on this platform.');
      }
      return;
    }

    // معالج الرسائل في الخلفية
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // طلب الأذونات
    await _requestPermissions();

    // تقديم الإشعارات أثناء المقدمة على iOS
    // على iOS: نعطّل alert في المقدمة ونعتمد على الإشعارات المحلية فقط لضبط السلوك (مثل الكتم داخل نفس المحادثة)
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: true,
      sound: true,
    );

    // تهيئة الإشعارات المحلية
    await NotificationService.initializePlatformNotifications();
    // تعامل مع النقر على الإشعار المحلي
    NotificationService.onTap = (payload) async {
      try {
        if (kDebugMode) {
          print('🔔 NotificationService.onTap called with payload: $payload');
        }
        if (payload == null || payload.isEmpty) return;
        final data = jsonDecode(payload) as Map<String, dynamic>;
        if (kDebugMode) {
          print('🔔 Decoded data: $data');
        }
        await PushMessagingService._routeFromData(data);
      } catch (e) {
        if (kDebugMode) {
          print('⚠️ Error in NotificationService.onTap: $e');
        }
      }
    };

    // Foreground messages → أظهر إشعاراً محلياً (مترجماً حسب لغة التطبيق)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final data = message.data;
      final type = (data['type'] ?? data['action'])?.toString();
      // حاول استخلاص conversationId من عدة مفاتيح مع دعم fallback عند الحاجة
      String? conversationId =
          data['conversation_id']?.toString() ??
          data['conv_id']?.toString() ??
          data['conversationId']?.toString();

      if (type == 'new_message') {
        final currentConv = ChatRouteTracker.currentConversationId.value;
        // إن لم يصل conversationId ضمن الحمولة، جرّب استنتاجه
        if ((conversationId == null || conversationId.isEmpty)) {
          try {
            // 1) إذا توفّر message_id أو id كمعرّف رسالة، استنتج منه المحادثة
            final msgId = (data['message_id'] ?? data['id'])?.toString();
            if (msgId != null && msgId.isNotEmpty) {
              final msg = await _client
                  .from('messages')
                  .select('conversation_id')
                  .eq('id', msgId)
                  .maybeSingle();
              conversationId = msg?['conversation_id']?.toString() ?? conversationId;
            }
          } catch (_) {}

          // 2) إذا لم نصل لشيء، وحملت البيانات other_user_id/sender_id/seller_id، ابحث عن أحدث محادثة معه
          if (conversationId == null || conversationId.isEmpty) {
            try {
              final currentUser = _client.auth.currentUser;
              final otherId = (data['other_user_id'] ?? data['sender_id'] ?? data['seller_id'])?.toString();
              if (currentUser != null && otherId != null && otherId.isNotEmpty) {
                final conv = await _client
                    .from('conversations')
                    .select('id')
                    .or('and(buyer_id.eq.${currentUser.id},seller_id.eq.$otherId),and(buyer_id.eq.$otherId,seller_id.eq.${currentUser.id})')
                    .order('last_message_at', ascending: false)
                    .limit(1)
                    .maybeSingle();
                conversationId = conv?['id']?.toString() ?? conversationId;
              }
            } catch (_) {}
          }
        }

        // لا تعرض إشعار محلي إذا كنت داخل نفس المحادثة
        if (currentConv != null &&
            currentConv.isNotEmpty &&
            conversationId != null &&
            conversationId.isNotEmpty &&
            currentConv == conversationId) {
          if (kDebugMode) {
            print('🔕 Suppressed notification: currently in conversation $conversationId');
          }
          // حتى مع الكتم، أعلِم الواجهة لتحديث عدادات غير المقروء (قد تُصبح صفراً)
          ChatRouteTracker.notifyIncomingMessage();
          return;
        }
      }

      // ابنِ العنوان/النص محليًا لضمان الترجمة الصحيحة وعدم استخدام نصوص خام من الخادم
      String title;
      String body;
      try {
        switch (type) {
          case 'new_message':
            final senderName = (data['sender_name'] ?? data['other_user_name'] ?? data['seller_name'] ?? '').toString();
            final preview = (data['preview'] ?? data['body'] ?? '').toString();
            title = 'notif_new_message_from'.tr(args: [senderName]);
            body = preview.isNotEmpty ? preview : 'notif_generic'.tr();
            break;
          case 'car_removed':
            final carTitle = (data['car_title'] ?? '').toString();
            final reason = (data['reason'] ?? '').toString();
            title = 'notif_car_removed_title'.tr(args: [carTitle]);
            body = 'notif_car_removed_body'.tr(args: [reason]);
            break;
          case 'new_offer':
          case 'offer_new':
          case 'offer_updated':
            final carTitle = (data['car_title'] ?? data['title'] ?? '').toString();
            final senderName = (data['sender_name'] ?? '').toString();
            title = 'notif_new_offer_title'.tr(args: [carTitle]);
            body = 'notif_new_offer_body'.tr(args: [senderName]);
            break;
          case 'car_like':
            final likerName = (data['liker_name'] ?? data['sender_name'] ?? '').toString();
            final carTitle = (data['car_title'] ?? '').toString();
            title = 'notif_like_title'.tr();
            body = 'notif_like_body'.tr(args: [likerName, carTitle]);
            break;
          case 'car_comment':
            final commenter = (data['commenter_name'] ?? data['sender_name'] ?? '').toString();
            final carTitle = (data['car_title'] ?? '').toString();
            final comment = (data['comment'] ?? data['body'] ?? '').toString();
            title = 'notif_comment_title'.tr(args: [carTitle]);
            body = comment.isNotEmpty
                ? 'notif_comment_body'.tr(args: [commenter, comment])
                : 'notif_generic'.tr();
            break;
          default:
            title = 'notification_default_title'.tr();
            body = (data['body'] ?? '').toString();
            if (body.isEmpty) body = 'notif_generic'.tr();
        }
      } catch (_) {
        // أي خطأ في الترجمة → عناوين افتراضية آمنة
        title = 'notification_default_title'.tr();
        body = 'notif_generic'.tr();
      }
      final payload = jsonEncode(data);

      if (kDebugMode) {
        print('🔔 Showing local notification with payload: $payload');
      }

      await NotificationService.showLocalNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: title,
        body: body,
        payload: payload,
      );

      // Notify UI to refresh unread badge when a new message arrives
      if (type == 'new_message') {
        ChatRouteTracker.notifyIncomingMessage();
      }
    });

    // إذا فُتح التطبيق من إشعار
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (kDebugMode) {
        print('🔔 onMessageOpenedApp - Opened from notification: ${message.data}');
        print('🔔 onMessageOpenedApp - Notification: ${message.notification?.toMap()}');
      }
      final data = message.data;
      final type = (data['type'] ?? data['action'])?.toString();
      if (type == 'new_message') {
        ChatRouteTracker.notifyIncomingMessage();
      }
      await PushMessagingService._routeFromData(message.data);
    });

    // رسالة الإطلاق (إذا فُتح التطبيق من إشعار وهو مغلق تماماً)
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null && kDebugMode) {
      print('🔔 getInitialMessage - Initial message: ${initial.data}');
      print('🔔 getInitialMessage - Notification: ${initial.notification?.toMap()}');
    }
    if (initial != null) {
      final data = initial.data;
      final type = (data['type'] ?? data['action'])?.toString();
      if (type == 'new_message') {
        ChatRouteTracker.notifyIncomingMessage();
      }
      await PushMessagingService._routeFromData(initial.data);
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
      try {
        await _client.from('user_devices').upsert({
          'user_id': user.id,
          'token': token,
          'platform': platform,
          'updated_at': DateTime.now().toIso8601String(),
        }, onConflict: 'token');
        
        if (kDebugMode) {
          print('✅ FCM token saved successfully');
        }
      } catch (deviceError) {
        if (kDebugMode) {
          print('⚠️ Failed to save to user_devices: $deviceError');
          print('🔄 Trying to update users table instead...');
        }
        
        // Fallback: حفظ FCM token في جدول users
        try {
          await _client.from('users').update({
            'fcm_token': token,
            'updated_at': DateTime.now().toIso8601String(),
          }).eq('id', user.id);
          
          if (kDebugMode) {
            print('✅ FCM token saved to users table as fallback');
          }
        } catch (usersError) {
          if (kDebugMode) {
            print('❌ Failed to save FCM token anywhere: $usersError');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ General error in FCM token handling: $e');
      }
    }
  }

  // جلب بيانات إشعار من جدول notifications عبر المعرّف
  static Future<Map<String, dynamic>?> _fetchNotificationById(String id) async {
    try {
      final row = await _client
          .from('notifications')
          .select('type,data')
          .eq('id', id)
          .maybeSingle();
      if (row == null) return null;
      final t = row['type']?.toString();
      final d = (row['data'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};
      if (t != null) d['type'] = t;
      return d;
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ _fetchNotificationById failed: $e');
      }
      return null;
    }
  }

  static Future<void> _routeFromData(Map<String, dynamic> data) async {
    try {
      if (kDebugMode) {
        print('🔔 _routeFromData called with data: $data');
      }
      final type = (data['type'] ?? data['action'])?.toString();
      if (kDebugMode) {
        print('🔔 Detected type: $type');
      }
      if (type == 'new_message' || data['action']?.toString() == 'open_chat') {
        String? conversationId =
            data['conversation_id']?.toString() ??
            data['conv_id']?.toString() ??
            data['conversationId']?.toString();

        // في بعض الأنظمة يصل 'id' كمعرف الرسالة وليس المحادثة
        if ((conversationId == null || conversationId.isEmpty) &&
            data['message_id'] != null) {
          try {
            final msg = await _client
                .from('messages')
                .select('conversation_id')
                .eq('id', data['message_id'])
                .maybeSingle();
            conversationId = msg?['conversation_id']?.toString();
          } catch (_) {}
        }

        // جرّب أيضاً استخدام id كرسالة لاستنتاج المحادثة
        if ((conversationId == null || conversationId.isEmpty) &&
            data['id'] != null) {
          try {
            final msg = await _client
                .from('messages')
                .select('conversation_id')
                .eq('id', data['id'])
                .maybeSingle();
            conversationId = msg?['conversation_id']?.toString();
          } catch (_) {}
        }

        // جرّب كذلك اعتبار id كمُعرّف محادثة مباشرة
        if ((conversationId == null || conversationId.isEmpty) &&
            data['id'] != null) {
          try {
            final conv = await _client
                .from('conversations')
                .select('id')
                .eq('id', data['id'])
                .maybeSingle();
            conversationId = conv?['id']?.toString();
          } catch (_) {}
        }

        // كحل أخير: إذا كان id هو معرّف إشعار، استرجع بيانات الإشعار واستخدمها
        if ((conversationId == null || conversationId.isEmpty) && data['id'] != null) {
          final notifData = await _fetchNotificationById(data['id']!.toString());
          if (kDebugMode) {
            print('🔔 Notification lookup for message returned: $notifData');
          }
          if (notifData != null) {
            final merged = {...notifData, ...data};
            // أعد المحاولة مع البيانات المُسترجعة
            await _routeFromData(merged);
            return;
          }
        }

        // إذا لم يتوفر conversationId لكن لدينا other_user_id أو sender_id أو seller_id، حاول إيجاد أحدث محادثة معه
        if ((conversationId == null || conversationId.isEmpty) &&
            (data['other_user_id'] != null || data['sender_id'] != null || data['seller_id'] != null)) {
          final currentUser = _client.auth.currentUser;
          final otherId = (data['other_user_id'] ?? data['sender_id'] ?? data['seller_id']).toString();
          if (currentUser != null && otherId.isNotEmpty) {
            try {
              final conv = await _client
                  .from('conversations')
                  .select('id')
                  .or('and(buyer_id.eq.${currentUser.id},seller_id.eq.$otherId),and(buyer_id.eq.$otherId,seller_id.eq.${currentUser.id})')
                  .order('last_message_at', ascending: false)
                  .limit(1)
                  .maybeSingle();
              conversationId = conv?['id']?.toString();
            } catch (_) {}
          }
        }

        if (conversationId != null && conversationId.isNotEmpty) {
          // حاول إثراء البيانات قبل التوجيه لضمان عدم ظهور خطأ البيانات الناقصة
          String? sellerIdExtra = data['seller_id']?.toString();
          String? sellerNameExtra = data['seller_name']?.toString() ?? data['other_user_name']?.toString() ?? data['sender_name']?.toString();
          String? sellerAvatarExtra = data['seller_avatar']?.toString();
          String? carIdExtra = data['car_id']?.toString();
          String? carTitleExtra = data['car_title']?.toString();

          // Fallback مبكر: إن لم نجد seller_id استخدم other_user_id أو sender_id من الحمولة
          sellerIdExtra ??= (data['other_user_id'] ?? data['sender_id'])?.toString();

          try {
            final currentUser = _client.auth.currentUser;
            final conv = await _client
                .from('conversations')
                .select('buyer_id,seller_id,car_id, car:cars!car_id(title), buyer:users!buyer_id(full_name,avatar_url,photo_url), seller:users!seller_id(full_name,avatar_url,photo_url)')
                .eq('id', conversationId)
                .maybeSingle();

            if (conv != null) {
              final buyerId = conv['buyer_id']?.toString();
              final sellerId = conv['seller_id']?.toString();
              final isCurrentBuyer =
                  currentUser != null && buyerId == currentUser.id;
              final other = isCurrentBuyer ? conv['seller'] : conv['buyer'];
              sellerIdExtra ??= isCurrentBuyer ? sellerId : buyerId;
              sellerNameExtra ??=
                  (other?['full_name'] ?? other?['display_name'] ?? other?['name'])
                      ?.toString();
              sellerAvatarExtra ??=
                  (other?['avatar_url'] ?? other?['photo_url'] ?? other?['picture'])
                      ?.toString();
              carIdExtra ??= conv['car_id']?.toString();
              carTitleExtra ??= conv['car']?['title']?.toString();
            }
          } catch (_) {}

          if (kDebugMode) {
            print('🔔 Routing to chat: $conversationId with extras: ${{
              'conversation_id': conversationId,
              if (sellerIdExtra != null) 'seller_id': sellerIdExtra,
              if (sellerNameExtra != null) 'seller_name': sellerNameExtra,
              if (sellerAvatarExtra != null) 'seller_avatar': sellerAvatarExtra,
              if (carIdExtra != null) 'car_id': carIdExtra,
              if (carTitleExtra != null) 'car_title': carTitleExtra,
            }}');
          }
          GRouter.router.go(
            '${GRouter.config.mainRoutes.messagesBasePage}/${GRouter.config.chatsRoutes.chatPage}',
            extra: {
              'conversation_id': conversationId,
              // مرّرنا أي معلومات إضافية إن توفرت أو تم إثراؤها
              if (sellerIdExtra != null) 'seller_id': sellerIdExtra,
              if (sellerNameExtra != null) 'seller_name': sellerNameExtra,
              if (sellerAvatarExtra != null) 'seller_avatar': sellerAvatarExtra,
              if (carIdExtra != null) 'car_id': carIdExtra,
              if (carTitleExtra != null) 'car_title': carTitleExtra,
            },
          );
          return;
        }

        // كملاذ أخير، افتح صفحة الرسائل العامة بدل اظهار خطأ
        if (kDebugMode) {
          print('🔔 Fallback: Opening messages base page');
        }
        GRouter.router.go(GRouter.config.mainRoutes.messagesBasePage);
        return;
      }

      // حاول تحليل الإشعارات العامة للحصول على البيانات من جدول notifications
      if (type == 'general' && data['id'] != null) {
        try {
          final notifData = await _fetchNotificationById(data['id']!.toString());
          if (kDebugMode) {
            print('🔔 Resolved general notification: $notifData');
          }
          if (notifData != null) {
            await _routeFromData(notifData);
            return;
          }
        } catch (e) {
          if (kDebugMode) {
            print('⚠️ Failed to resolve general notification: $e');
          }
        }
      }

      // أنواع السيارات المحتملة
      final carTypes = {
        'view_car',
        'price_drop',
        'price_change',
        'car_price_changed',
        'car_status_changed',
        'car_state_changed',
        'car_updated',
        'car_like',
        'car_comment',
        'view_comments',
        'offer_new',
        'offer_updated',
        'car_sold',
        'car_approved',
      };

      if (data.containsKey('car_id') ||
          data['action']?.toString() == 'view_car' ||
          (type != null && carTypes.contains(type))) {
        String? carId = data['car_id']?.toString();
        // لا تعتمد على id مباشرة (قد يكون id هو معرّف إشعار)، حاول جلب بيانات الإشعار إذا carId غير موجودة
        if ((carId == null || carId.isEmpty) && data['id'] != null) {
          final notifData = await _fetchNotificationById(data['id']!.toString());
          if (kDebugMode) {
            print('🔔 Notification lookup for car returned: $notifData');
          }
          carId = notifData?['car_id']?.toString() ?? carId;
        }
        if (kDebugMode) {
          print('🔔 Car notification detected. car_id: ${data['car_id']}, id: ${data['id']}, final carId: $carId');
        }
        if (carId != null && carId.isNotEmpty) {
          if (kDebugMode) {
            print('🔔 Routing to car details: $carId');
            print('🔔 Full path: ${GRouter.config.mainRoutes.home}/${GRouter.config.homeRoutes.carDetails}');
          }
          GRouter.router.go(
            '${GRouter.config.mainRoutes.home}/${GRouter.config.homeRoutes.carDetails}',
            extra: {
              'id': carId,
            },
          );
        } else {
          if (kDebugMode) {
            print('🔔 No valid car ID found in notification data');
          }
        }
        return;
      }
      
      if (kDebugMode) {
        print('🔔 No notification type detected, checking general routing...');
        print('🔔 Available keys in data: ${data.keys.toList()}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Routing from push failed: $e');
        print('⚠️ Stack trace: ${StackTrace.current}');
      }
    }
  }
}
