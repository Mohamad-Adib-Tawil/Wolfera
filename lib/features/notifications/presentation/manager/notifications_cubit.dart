import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wolfera/services/notification_service.dart';
import 'package:easy_localization/easy_localization.dart';

@lazySingleton
class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(const NotificationsState());
  
  final _client = Supabase.instance.client;
  RealtimeChannel? _notificationsChannel;
  StreamSubscription? _authSubscription;
  
  // تهيئة الإشعارات
  Future<void> initialize() async {
    // تهيئة الإشعارات المحلية
    await NotificationService.initializePlatformNotifications();
    
    // الاستماع لتغيرات حالة المصادقة
    _authSubscription = _client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null) {
        _subscribeToNotifications(session.user.id);
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
      final unreadCount = notifications.where((n) => n['read_at'] == null).length;
      
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
              
              // عرض إشعار محلي
              _showLocalNotification(notification);
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
              final unreadCount = updatedList.where((n) => n['read_at'] == null).length;
              
              emit(state.copyWith(
                notifications: updatedList,
                unreadCount: unreadCount,
              ));
            }
          },
        )
        .subscribe();
  }
  
  // إلغاء الاشتراك
  void _unsubscribeFromNotifications() {
    _notificationsChannel?.unsubscribe();
    _notificationsChannel = null;
  }
  
  // عرض إشعار محلي
  void _showLocalNotification(Map<String, dynamic> notification) {
    final type = notification['type']?.toString() ?? 'general';
    final data = (notification['data'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};
    String title = notification['title']?.toString() ?? 'notification'.tr();
    String body = notification['body']?.toString() ?? '';

    try {
      switch (type) {
        case 'new_message':
          final senderName = (data['sender_name'] ?? data['other_user_name'] ?? '').toString();
          final preview = (data['preview'] ?? '').toString();
          title = 'notif_new_message_from'.tr(namedArgs: {'name': senderName});
          body = preview.isNotEmpty ? preview : 'notif_generic'.tr();
          break;
        case 'new_offer':
          final carTitle = (data['car_title'] ?? data['title'] ?? '').toString();
          final senderName = (data['sender_name'] ?? '').toString();
          title = 'notif_new_offer_title'.tr(args: [carTitle]);
          body = 'notif_new_offer_body'.tr(args: [senderName]);
          break;
        case 'car_like':
          final liker = (data['liker_name'] ?? data['sender_name'] ?? '').toString();
          final carTitle = (data['car_title'] ?? '').toString();
          title = 'notif_like_title'.tr();
          body = 'notif_like_body'.tr(args: [liker, carTitle]);
          break;
        case 'car_comment':
          final commenter = (data['commenter_name'] ?? data['sender_name'] ?? '').toString();
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

    NotificationService.showLocalNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      payload: '{"type": "$type", "id": "${notification['id']}"}',
    );
  }
  
  // تحديد إشعار كمقروء
  Future<void> markAsRead(String notificationId) async {
    try {
      await _client
          .from('notifications')
          .update({'read_at': DateTime.now().toIso8601String()})
          .eq('id', notificationId);
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
      await _client
          .from('notifications')
          .delete()
          .eq('id', notificationId);
      
      // إزالة من القائمة المحلية
      final updatedList = state.notifications.where((n) => n['id'] != notificationId).toList();
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
      
      await _client
          .from('notifications')
          .delete()
          .eq('user_id', userId);
      
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
