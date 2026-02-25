import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ChatService {
  final SupabaseClient _client = Supabase.instance.client;
  final Map<String, Map<String, dynamic>> _senderCache = {};

  // Stream subscriptions
  final Map<String, RealtimeChannel> _subscriptions = {};

  // ==================== المحادثات ====================

  Future<Map<String, dynamic>?> _reactivateConversationIfNeeded(
    Map<String, dynamic> conversation,
  ) async {
    try {
      final id = conversation['id']?.toString();
      if (id == null) return conversation;
      if (conversation['is_active'] == true) return conversation;

      await _client.from('conversations').update({
        'is_active': true,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', id);

      final refreshed = await _client
          .from('conversations')
          .select(
              'id,buyer_id,seller_id,car_id,is_active,last_message,last_message_at,updated_at, buyer:users!buyer_id(id,full_name,avatar_url,photo_url), seller:users!seller_id(id,full_name,avatar_url,photo_url), car:cars!car_id(id,title,user_id)')
          .eq('id', id)
          .maybeSingle();
      return refreshed ?? conversation;
    } catch (e) {
      print('⚠️ Could not reactivate conversation: $e');
      return conversation;
    }
  }

  /// إنشاء أو استرجاع محادثة
  Future<Map<String, dynamic>?> getOrCreateConversation({
    required String carId,
    required String buyerId,
    required String sellerId,
  }) async {
    try {
      // محاولة جلب المحادثة الموجودة
      final existing = await _client
          .from('conversations')
          .select(
              'id,buyer_id,seller_id,car_id,is_active,last_message,last_message_at,updated_at, buyer:users!buyer_id(id,full_name,avatar_url,photo_url), seller:users!seller_id(id,full_name,avatar_url,photo_url), car:cars!car_id(id,title,user_id)')
          .eq('car_id', carId)
          .eq('buyer_id', buyerId)
          .eq('seller_id', sellerId)
          .maybeSingle();

      if (existing != null) {
        return await _reactivateConversationIfNeeded(existing);
      }

      // جرّب الأدوار المعكوسة (في حال كان المستخدم الحالي هو البائع)
      final reversed = await _client
          .from('conversations')
          .select(
              'id,buyer_id,seller_id,car_id,is_active,last_message,last_message_at,updated_at, buyer:users!buyer_id(id,full_name,avatar_url,photo_url), seller:users!seller_id(id,full_name,avatar_url,photo_url), car:cars!car_id(id,title,user_id)')
          .eq('car_id', carId)
          .eq('buyer_id', sellerId)
          .eq('seller_id', buyerId)
          .maybeSingle();

      if (reversed != null) {
        return await _reactivateConversationIfNeeded(reversed);
      }

      // إنشاء محادثة جديدة إذا لم توجد
      final newConversation = await _client
          .from('conversations')
          .insert({
            'car_id': carId,
            'buyer_id': buyerId,
            'seller_id': sellerId,
            'is_active': true,
          })
          .select(
              'id,buyer_id,seller_id,car_id,is_active,last_message,last_message_at,updated_at, buyer:users!buyer_id(id,full_name,avatar_url,photo_url), seller:users!seller_id(id,full_name,avatar_url,photo_url), car:cars!car_id(id,title,user_id)')
          .single();

      return newConversation;
    } catch (e) {
      print('❌ Error in getOrCreateConversation: $e');
      return null;
    }
  }

  /// حذف رسالة واحدة نهائياً من قاعدة البيانات
  Future<bool> deleteMessage({required String messageId}) async {
    try {
      await _client.from('messages').delete().eq('id', messageId);
      return true;
    } catch (e) {
      print('❌ Error deleting message: $e');
      return false;
    }
  }

  /// تفريغ جميع رسائل المحادثة مع إرسال رسالة نظام تُعلم الطرف الآخر
  Future<bool> clearConversation({
    required String conversationId,
    required String actorId,
  }) async {
    try {
      // احذف جميع الرسائل مباشرة
      await _client
          .from('messages')
          .delete()
          .eq('conversation_id', conversationId);

      // أرسل رسالة عادية لإعلام الطرف الآخر
      try {
        await _client.from('messages').insert({
          'conversation_id': conversationId,
          'sender_id': actorId,
          'message_type': 'text',
          'message_text': 'تم مسح المحادثة',
        });
      } catch (e) {
        print('⚠️ Could not send system message: $e');
        // لا بأس إذا فشل إرسال رسالة النظام
      }

      // تحديث بيانات المحادثة
      try {
        await _client.from('conversations').update({
          'last_message': 'تم مسح المحادثة',
          'last_message_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        }).eq('id', conversationId);
      } catch (e) {
        print('⚠️ Could not update conversation meta: $e');
      }

      return true;
    } catch (e) {
      print('❌ Error clearing conversation: $e');
      return false;
    }
  }

  /// أرشفة محادثة (إخفاؤها) عبر جعل is_active = false
  Future<bool> archiveConversation(String conversationId) async {
    try {
      await _client
          .from('conversations')
          .update({'is_active': false}).eq('id', conversationId);
      return true;
    } catch (e) {
      print('❌ Error archiving conversation: $e');
      return false;
    }
  }

  /// استعادة محادثة مخفية عبر جعل is_active = true
  Future<bool> restoreConversation(String conversationId) async {
    try {
      await _client
          .from('conversations')
          .update({'is_active': true}).eq('id', conversationId);
      return true;
    } catch (e) {
      print('❌ Error restoring conversation: $e');
      return false;
    }
  }

  /// جلب المحادثات المخفية للمستخدم
  Future<List<Map<String, dynamic>>> getArchivedConversations(
      String userId) async {
    try {
      print(
          '🔍 [ChatService] Fetching archived conversations for user: $userId');

      final response = await _client
          .from('conversations')
          .select(
              'id,buyer_id,seller_id,car_id,is_active,last_message,last_message_at,updated_at,buyer_unread_count,seller_unread_count, buyer:users!buyer_id(id,full_name,avatar_url,photo_url), seller:users!seller_id(id,full_name,avatar_url,photo_url), car:cars!car_id(id,title,user_id)')
          .or('buyer_id.eq.$userId,seller_id.eq.$userId')
          .eq('is_active', false)
          .order('updated_at', ascending: false);

      print('🔍 [ChatService] Found ${response.length} archived conversations');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ [ChatService] Error fetching archived conversations: $e');
      return [];
    }
  }

  /// حذف محادثة نهائيًا (قد يتطلب قيود ON DELETE CASCADE في قاعدة البيانات)
  Future<bool> deleteConversation(String conversationId) async {
    try {
      await _client.from('conversations').delete().eq('id', conversationId);
      return true;
    } catch (e) {
      print('❌ Error deleting conversation: $e');
      return false;
    }
  }

  /// جلب كل محادثات المستخدم
  Future<List<Map<String, dynamic>>> getUserConversations(String userId) async {
    try {
      print('🔍 [ChatService] Fetching conversations for user: $userId');

      final response = await _client
          .from('conversations')
          .select(
              'id,buyer_id,seller_id,car_id,is_active,last_message,last_message_at,updated_at,buyer_unread_count,seller_unread_count, buyer:users!buyer_id(id,full_name,avatar_url,photo_url), seller:users!seller_id(id,full_name,avatar_url,photo_url), car:cars!car_id(id,title,user_id)')
          .or('buyer_id.eq.$userId,seller_id.eq.$userId')
          .eq('is_active', true)
          .order('last_message_at', ascending: false);

      print('🔍 [ChatService] Raw response count: ${response.length}');

      if (response.isEmpty) {
        print(
            '⚠️ [ChatService] No conversations found. Checking if any exist without is_active filter...');

        // Check if conversations exist without is_active filter
        final allConversations = await _client
            .from('conversations')
            .select(
                'id,buyer_id,seller_id,car_id,is_active,last_message,last_message_at,updated_at')
            .or('buyer_id.eq.$userId,seller_id.eq.$userId');

        print(
            '🔍 [ChatService] Total conversations (including inactive): ${allConversations.length}');

        for (final conv in allConversations) {
          print(
              '   - Conv ${conv['id']}: buyer=${conv['buyer_id']}, seller=${conv['seller_id']}, active=${conv['is_active']}');
        }
      } else {
        print('✅ [ChatService] Found ${response.length} active conversations');
        for (final conv in response) {
          print(
              '   - Conv ${conv['id']}: buyer=${conv['buyer_id']}, seller=${conv['seller_id']}, last_msg="${conv['last_message']}"');
        }
      }

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ [ChatService] Error fetching conversations: $e');
      print('❌ [ChatService] Error type: ${e.runtimeType}');
      if (e is PostgrestException) {
        print('❌ [ChatService] Postgrest error details: ${e.details}');
        print('❌ [ChatService] Postgrest error hint: ${e.hint}');
        print('❌ [ChatService] Postgrest error code: ${e.code}');
      }
      return [];
    }
  }

  /// جلب محادثة واحدة بالتفصيل
  Future<Map<String, dynamic>?> getConversation(String conversationId) async {
    try {
      return await _client
          .from('conversations')
          .select(
              'id,buyer_id,seller_id,car_id,is_active,last_message,last_message_at,updated_at,buyer_unread_count,seller_unread_count, buyer:users!buyer_id(id,full_name,avatar_url,photo_url), seller:users!seller_id(id,full_name,avatar_url,photo_url), car:cars!car_id(id,title,user_id)')
          .eq('id', conversationId)
          .single();
    } catch (e) {
      print('❌ Error fetching conversation: $e');
      return null;
    }
  }

  // ==================== الرسائل ====================

  /// إرسال رسالة
  Future<Map<String, dynamic>?> sendMessage({
    required String conversationId,
    required String senderId,
    required String messageText,
    String messageType = 'text',
    List<String>? attachments,
  }) async {
    try {
      final message = await _client
          .from('messages')
          .insert({
            'conversation_id': conversationId,
            'sender_id': senderId,
            'message_text': messageText,
            'message_type': messageType,
            'attachments': attachments ?? [],
          })
          .select(
              'id,conversation_id,sender_id,message_text,message_type,attachments,created_at,read_at, sender:users!sender_id(id,full_name,avatar_url,photo_url)')
          .single();

      // تحديث بيانات المحادثة لعرض آخر رسالة في قائمة المحادثات
      try {
        await _client.from('conversations').update({
          'is_active': true,
          'last_message': messageText,
          'last_message_at':
              message['created_at'] ?? DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        }).eq('id', conversationId);
      } catch (e) {
        // غير حرجة؛ قد تفشل بسبب RLS إذا لم تُضف سياسات التحديث للمشاركين
        print('⚠️ Could not update conversation meta: $e');
      }

      // إشعار الرسالة يُرسل الآن من تريجر قاعدة البيانات (send_message_notification).
      // تم إزالة الإرسال من التطبيق لتفادي التكرار.

      return message;
    } catch (e) {
      print('❌ Error sending message: $e');
      return null;
    }
  }

  /// جلب رسائل محادثة
  Future<List<Map<String, dynamic>>> getMessages({
    required String conversationId,
    int limit = 30,
    int offset = 0,
  }) async {
    try {
      final response = await _client
          .from('messages')
          .select(
              'id,conversation_id,sender_id,message_text,message_type,attachments,created_at,read_at, sender:users!sender_id(id,full_name,avatar_url,photo_url)')
          .eq('conversation_id', conversationId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      // عكس الترتيب لعرض الأقدم أولاً
      return List<Map<String, dynamic>>.from(response.reversed);
    } catch (e) {
      print('❌ Error fetching messages: $e');
      return [];
    }
  }

  /// تحديد الرسائل كمقروءة
  Future<void> markMessagesAsRead({
    required String conversationId,
    required String userId,
  }) async {
    try {
      await _client.rpc('mark_messages_as_read', params: {
        'p_conversation_id': conversationId,
        'p_user_id': userId,
      });
    } catch (e) {
      print('❌ Error marking messages as read: $e');
    }
  }

  // ==================== Realtime ====================

  /// الاشتراك في تحديثات المحادثة
  RealtimeChannel subscribeToConversation({
    required String conversationId,
    required Function(Map<String, dynamic>) onNewMessage,
    Function(Map<String, dynamic>)? onMessageUpdate,
    Function(Map<String, dynamic>)? onMessageDelete,
  }) {
    // إلغاء الاشتراك السابق إن وجد
    unsubscribeFromConversation(conversationId);

    final channel = _client.channel('conversation_$conversationId');

    channel.onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'messages',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'conversation_id',
        value: conversationId,
      ),
      callback: (payload) async {
        // جلب بيانات المرسل
        final messageWithSender =
            await _enrichMessageWithSender(payload.newRecord);
        onNewMessage(messageWithSender);
      },
    );

    // الاشتراك في تحديثات الرسائل (مثل حالة القراءة)
    if (onMessageUpdate != null) {
      channel.onPostgresChanges(
        event: PostgresChangeEvent.update,
        schema: 'public',
        table: 'messages',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'conversation_id',
          value: conversationId,
        ),
        callback: (payload) async {
          final messageWithSender =
              await _enrichMessageWithSender(payload.newRecord);
          onMessageUpdate(messageWithSender);
        },
      );
    }

    if (onMessageDelete != null) {
      channel.onPostgresChanges(
        event: PostgresChangeEvent.delete,
        schema: 'public',
        table: 'messages',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'conversation_id',
          value: conversationId,
        ),
        callback: (payload) async {
          onMessageDelete(payload.oldRecord);
        },
      );
    }

    channel.subscribe();
    _subscriptions[conversationId] = channel;

    return channel;
  }

  /// إلغاء الاشتراك في المحادثة
  void unsubscribeFromConversation(String conversationId) {
    final channel = _subscriptions[conversationId];
    if (channel != null) {
      channel.unsubscribe();
      _subscriptions.remove(conversationId);
    }
  }

  /// الاشتراك في كل محادثات المستخدم
  RealtimeChannel subscribeToUserConversations({
    required String userId,
    required Function(Map<String, dynamic>) onConversationUpdate,
  }) {
    final channel = _client.channel('user_conversations_$userId');

    channel.onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'conversations',
      callback: (payload) async {
        final base = payload.newRecord.isNotEmpty
            ? payload.newRecord
            : payload.oldRecord;
        if (base.isEmpty) return;
        // تأكد أن المستخدم طرف في المحادثة
        if (base['buyer_id'] != userId && base['seller_id'] != userId) return;
        try {
          final enriched = await _client
              .from('conversations')
              .select(
                  '*, buyer:users!buyer_id(*), seller:users!seller_id(*), car:cars!car_id(*)')
              .eq('id', base['id'])
              .maybeSingle();
          if (enriched != null) {
            onConversationUpdate(enriched);
          } else {
            onConversationUpdate(base);
          }
        } catch (_) {
          onConversationUpdate(base);
        }
      },
    );

    channel.subscribe();
    return channel;
  }

  /// إضافة بيانات المرسل للرسالة
  Future<Map<String, dynamic>> _enrichMessageWithSender(
      Map<String, dynamic> message) async {
    try {
      final senderId = message['sender_id']?.toString();
      if (senderId == null) return message;
      if (_senderCache.containsKey(senderId)) {
        return {
          ...message,
          'sender': _senderCache[senderId],
        };
      }
      final sender = await _client
          .from('users')
          .select('id,full_name,avatar_url,photo_url')
          .eq('id', senderId)
          .single();
      _senderCache[senderId] = sender;

      return {
        ...message,
        'sender': sender,
      };
    } catch (e) {
      return message;
    }
  }

  /// تنظيف كل الاشتراكات
  void dispose() {
    for (final channel in _subscriptions.values) {
      channel.unsubscribe();
    }
    _subscriptions.clear();
  }

  /// حساب عدد الرسائل غير المقروءة لمستخدم
  Future<int> getUnreadCount(String userId) async {
    try {
      // جلب كل المحادثات
      final conversations = await getUserConversations(userId);
      int totalUnread = 0;

      for (final conv in conversations) {
        final conversationId = conv['id']?.toString();
        if (conversationId == null) continue;

        // حساب الرسائل غير المقروءة من جدول messages مباشرة
        try {
          final response = await _client
              .from('messages')
              .select('id')
              .eq('conversation_id', conversationId)
              .neq('sender_id', userId) // رسائل من الآخرين فقط
              .isFilter('read_at', null); // غير مقروءة

          final count = response.length;
          totalUnread += count;
        } catch (e) {
          print(
              '❌ [DEBUG] Error counting messages for conv $conversationId: $e');
        }
      }

      print('🔍 [DEBUG] Total unread messages: $totalUnread');
      return totalUnread;
    } catch (e) {
      print('❌ Error getting unread count: $e');
      return 0;
    }
  }

  /// حساب الرسائل غير المقروءة لمحادثة واحدة
  Future<int> getUnreadMessagesForConversation(
      String conversationId, String userId) async {
    try {
      final response = await _client
          .from('messages')
          .select('id')
          .eq('conversation_id', conversationId)
          .neq('sender_id', userId) // رسائل من الآخرين فقط
          .isFilter('read_at', null); // غير مقروءة

      return response.length;
    } catch (e) {
      print(
          '❌ Error counting unread messages for conversation $conversationId: $e');
      return 0;
    }
  }
}
