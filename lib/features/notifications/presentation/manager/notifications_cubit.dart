import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wolfera/services/notification_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wolfera/services/chat_route_tracker.dart';

@lazySingleton
class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(const NotificationsState());

  final _client = Supabase.instance.client;
  RealtimeChannel? _notificationsChannel;
  RealtimeChannel? _messagesChannel;
  StreamSubscription? _authSubscription;
  final Set<String> _shownMessageIds = <String>{};

  // تهيئة الإشعارات
  Future<void> initialize() async {
    // تهيئة الإشعارات المحلية
    await NotificationService.initializePlatformNotifications();

    // الاستماع لتغيرات حالة المصادقة
    _authSubscription = _client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null) {
        _subscribeToNotifications(session.user.id);
        _subscribeToIncomingMessages(session.user.id);
        loadNotifications();
      } else {
        _unsubscribeFromNotifications();
        emit(const NotificationsState());
      }
    });

    // إذا كان المستخدم مسجل الدخول بالفعل
    final currentUser = _client.auth.currentUser;
    if (currentUser != null) {
      _subscribeToNotifications(currentUser.id);
      _subscribeToIncomingMessages(currentUser.id);
      if (kDebugMode) {
        print(
            '🔔 [NotificationsCubit] Initialized for user: ${currentUser.id}');
      }
      await loadNotifications();
    }
  }

  // تحميل الإشعارات
  Future<void> loadNotifications() async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        emit(state.copyWith(isLoading: false));
        return;
      }

      final response = await _client
          .from('notifications')
          .select('*, sender:sender_id(id, full_name, avatar_url)')
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(50);

      final notifications = List<Map<String, dynamic>>.from(response);

      // حساب عدد الإشعارات غير المقروءة
      final unreadCount =
          notifications.where((n) => n['read_at'] == null).length;

      emit(state.copyWith(
        notifications: notifications,
        unreadCount: unreadCount,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: 'فشل تحميل الإشعارات',
        isLoading: false,
      ));
    }
  }

  // الاشتراك في الإشعارات الفورية
  void _subscribeToNotifications(String userId) {
    _unsubscribeFromNotifications();

    _notificationsChannel = _client.channel('notifications_$userId');

    _notificationsChannel!
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) async {
            final notification = payload.newRecord;
            if (notification.isNotEmpty) {
              // إضافة بيانات المرسل
              if (notification['sender_id'] != null) {
                try {
                  final sender = await _client
                      .from('users')
                      .select('id, full_name, avatar_url')
                      .eq('id', notification['sender_id'])
                      .single();
                  notification['sender'] = sender;
                } catch (_) {}
              }

              // إضافة الإشعار للقائمة
              final updatedList = [notification, ...state.notifications];
              emit(state.copyWith(
                notifications: updatedList,
                unreadCount: state.unreadCount + 1,
              ));

              // عرض إشعار محلي (مع كتم إذا كنت ضمن نفس المحادثة)
              await _showLocalNotification(notification);
            }
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'notifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) {
            final updated = payload.newRecord;
            if (updated.isNotEmpty) {
              final updatedList = state.notifications.map((n) {
                if (n['id'] == updated['id']) {
                  return {...n, ...updated};
                }
                return n;
              }).toList();

              // إعادة حساب عدد غير المقروء
              final unreadCount =
                  updatedList.where((n) => n['read_at'] == null).length;

              emit(state.copyWith(
                notifications: updatedList,
                unreadCount: unreadCount,
              ));
            }
          },
        )
        .subscribe();
  }

  // fallback: إشعار محلي مباشر عند وصول رسالة جديدة عبر Realtime
  // يفيد في iOS عندما لا يصل FCM أو لا يتم إدراج notifications لأي سبب.
  void _subscribeToIncomingMessages(String userId) {
    _messagesChannel?.unsubscribe();
    _messagesChannel = _client.channel('incoming_messages_$userId');

    _messagesChannel!
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          callback: (payload) async {
            final msg = payload.newRecord;
            if (msg.isEmpty) return;

            final messageId = msg['id']?.toString();
            final senderId = msg['sender_id']?.toString();
            final conversationId = msg['conversation_id']?.toString();
            if (messageId == null ||
                senderId == null ||
                conversationId == null ||
                senderId == userId) {
              return;
            }
            if (kDebugMode) {
              print(
                  '🔔 [RealtimeMsgFallback] message_id=$messageId conversation_id=$conversationId sender_id=$senderId');
            }

            // منع التكرار إذا ظهر نفس message_id عبر مسار notifications.
            if (_shownMessageIds.contains(messageId)) return;

            try {
              final conv = await _client
                  .from('conversations')
                  .select('id,buyer_id,seller_id')
                  .eq('id', conversationId)
                  .maybeSingle();
              if (conv == null) return;
              final isParticipant =
                  conv['buyer_id'] == userId || conv['seller_id'] == userId;
              if (!isParticipant) return;
            } catch (_) {
              return;
            }

            final currentConv = ChatRouteTracker.currentConversationId.value;
            if (currentConv != null &&
                currentConv.isNotEmpty &&
                currentConv == conversationId) {
              ChatRouteTracker.notifyIncomingMessage();
              return;
            }

            String senderName = 'User';
            try {
              final sender = await _client
                  .from('users')
                  .select('full_name')
                  .eq('id', senderId)
                  .maybeSingle();
              senderName = (sender?['full_name'] ?? senderName).toString();
            } catch (_) {}

            final preview = (msg['message_text'] ?? '').toString();
            final title =
                'notif_new_message_from'.tr(namedArgs: {'name': senderName});
            final body = preview.isNotEmpty ? preview : 'notif_generic'.tr();

            _shownMessageIds.add(messageId);
            if (_shownMessageIds.length > 500) {
              _shownMessageIds.remove(_shownMessageIds.first);
            }

            await NotificationService.showLocalNotification(
              id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
              title: title,
              body: body,
              payload:
                  '{"type":"new_message","conversation_id":"$conversationId","message_id":"$messageId"}',
            );
            if (kDebugMode) {
              print('🔔 [RealtimeMsgFallback] Local notification shown');
            }
            ChatRouteTracker.notifyIncomingMessage();
          },
        )
        .subscribe();
  }

  // إلغاء الاشتراك
  void _unsubscribeFromNotifications() {
    _notificationsChannel?.unsubscribe();
    _notificationsChannel = null;
    _messagesChannel?.unsubscribe();
    _messagesChannel = null;
  }

  // عرض إشعار محلي (مع كتم إشعار الرسائل داخل نفس المحادثة المفتوحة)
  Future<void> _showLocalNotification(Map<String, dynamic> notification) async {
    final type = notification['type']?.toString() ?? 'general';
    final data = (notification['data'] as Map?)?.cast<String, dynamic>() ??
        <String, dynamic>{};
    final messageId = (data['message_id'] ?? '').toString();
    String title = notification['title']?.toString() ?? 'notification'.tr();
    String body = notification['body']?.toString() ?? '';

    // كتم إشعار الرسالة الجديدة إذا كنا داخل نفس المحادثة
    if (type == 'new_message') {
      // جرّب استخراج conversationId من البيانات مباشرة
      String? conversationId = data['conversation_id']?.toString() ??
          data['conv_id']?.toString() ??
          data['conversationId']?.toString();

      // إذا لم يوجد، حاول الاستنتاج عبر message_id
      if (conversationId == null || conversationId.isEmpty) {
        try {
          final msgId = (data['message_id'] ?? data['id'])?.toString();
          if (msgId != null && msgId.isNotEmpty) {
            final msg = await _client
                .from('messages')
                .select('conversation_id')
                .eq('id', msgId)
                .maybeSingle();
            conversationId =
                msg?['conversation_id']?.toString() ?? conversationId;
          }
        } catch (_) {}
      }

      // إذا ما زال غير معروف، حاول الاستنتاج من معرف الطرف الآخر
      if (conversationId == null || conversationId.isEmpty) {
        try {
          final currentUser = _client.auth.currentUser;
          final otherId =
              (data['other_user_id'] ?? data['sender_id'] ?? data['seller_id'])
                  ?.toString();
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

      final currentConv = ChatRouteTracker.currentConversationId.value;
      if (currentConv != null &&
          currentConv.isNotEmpty &&
          conversationId != null &&
          conversationId.isNotEmpty &&
          currentConv == conversationId) {
        // لا تعرض إشعارًا إذا كانت الرسالة لنفس المحادثة المفتوحة حاليًا
        ChatRouteTracker.notifyIncomingMessage();
        return;
      }

      // منع التكرار إن كان تم عرضه عبر fallback messages subscription
      if (messageId.isNotEmpty && _shownMessageIds.contains(messageId)) {
        return;
      }
    }

    try {
      switch (type) {
        case 'new_message':
          final senderName =
              (data['sender_name'] ?? data['other_user_name'] ?? '').toString();
          final preview = (data['preview'] ?? '').toString();
          title = 'notif_new_message_from'.tr(namedArgs: {'name': senderName});
          body = preview.isNotEmpty ? preview : 'notif_generic'.tr();
          break;
        case 'new_offer':
          final carTitle =
              (data['car_title'] ?? data['title'] ?? '').toString();
          final senderName = (data['sender_name'] ?? '').toString();
          title = 'notif_new_offer_title'.tr(args: [carTitle]);
          body = 'notif_new_offer_body'.tr(args: [senderName]);
          break;
        case 'car_like':
          final liker =
              (data['liker_name'] ?? data['sender_name'] ?? '').toString();
          final carTitle = (data['car_title'] ?? '').toString();
          title = 'notif_like_title'.tr();
          body = 'notif_like_body'.tr(args: [liker, carTitle]);
          break;
        case 'car_comment':
          final commenter =
              (data['commenter_name'] ?? data['sender_name'] ?? '').toString();
          final carTitle = (data['car_title'] ?? '').toString();
          final comment = (data['comment'] ?? '').toString();
          title = 'notif_comment_title'.tr(args: [carTitle]);
          body = comment.isNotEmpty
              ? 'notif_comment_body'.tr(args: [commenter, comment])
              : 'notif_generic'.tr();
          break;
        case 'car_removed':
          final carTitle = (data['car_title'] ?? '').toString();
          final reason = (data['reason'] ?? '').toString();
          title = 'notif_car_removed_title'.tr(args: [carTitle]);
          body = 'notif_car_removed_body'.tr(args: [reason]);
          break;
        default:
          break;
      }
    } catch (_) {}

    await NotificationService.showLocalNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      payload: '{"type": "$type", "id": "${notification['id']}"}',
    );
    if (type == 'new_message' && messageId.isNotEmpty) {
      _shownMessageIds.add(messageId);
      if (_shownMessageIds.length > 500) {
        _shownMessageIds.remove(_shownMessageIds.first);
      }
    }
  }

  // تحديد إشعار كمقروء
  Future<void> markAsRead(String notificationId) async {
    try {
      await _client
          .from('notifications')
          .update({'read_at': DateTime.now().toIso8601String()}).eq(
              'id', notificationId);
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  // تحديد كل الإشعارات كمقروءة
  Future<void> markAllAsRead() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return;

      await _client
          .from('notifications')
          .update({'read_at': DateTime.now().toIso8601String()})
          .eq('user_id', userId)
          .filter('read_at', 'is', null);

      // تحديث الحالة المحلية
      final updatedList = state.notifications.map((n) {
        if (n['read_at'] == null) {
          return {...n, 'read_at': DateTime.now().toIso8601String()};
        }
        return n;
      }).toList();

      emit(state.copyWith(
        notifications: updatedList,
        unreadCount: 0,
      ));
    } catch (e) {
      print('Error marking all notifications as read: $e');
    }
  }

  // حذف إشعار
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _client.from('notifications').delete().eq('id', notificationId);

      // إزالة من القائمة المحلية
      final updatedList =
          state.notifications.where((n) => n['id'] != notificationId).toList();
      final unreadCount = updatedList.where((n) => n['read_at'] == null).length;

      emit(state.copyWith(
        notifications: updatedList,
        unreadCount: unreadCount,
      ));
    } catch (e) {
      print('Error deleting notification: $e');
    }
  }

  // حذف كل الإشعارات
  Future<void> clearAllNotifications() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return;

      await _client.from('notifications').delete().eq('user_id', userId);

      emit(state.copyWith(
        notifications: [],
        unreadCount: 0,
      ));
    } catch (e) {
      print('Error clearing notifications: $e');
    }
  }

  @override
  Future<void> close() {
    _unsubscribeFromNotifications();
    _authSubscription?.cancel();
    return super.close();
  }
}

// NotificationsState class
class NotificationsState {
  final List<Map<String, dynamic>> notifications;
  final int unreadCount;
  final bool isLoading;
  final String? error;

  const NotificationsState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.isLoading = false,
    this.error,
  });

  NotificationsState copyWith({
    List<Map<String, dynamic>>? notifications,
    int? unreadCount,
    bool? isLoading,
    String? error,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
