import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wolfera/services/chat_service.dart';
import 'package:wolfera/services/supabase_service.dart';

// Chat State is defined at the bottom of this file

@lazySingleton
class ChatCubit extends Cubit<ChatState> {
  final ChatService _chatService;
  
  RealtimeChannel? _messagesSubscription;
  String? _currentConversationId;
  
  ChatCubit(this._chatService) : super(const ChatState());
  
  /// تهيئة المحادثة
  Future<void> initializeConversation({
    required String? sellerId,
    required String? carId,
    String? sellerName,
    String? carTitle,
    String? conversationId,
  }) async {
    emit(state.copyWith(isLoading: true, error: null));
    
    try {
      final currentUser = SupabaseService.currentUser;
      if (currentUser == null) {
        emit(state.copyWith(
          isLoading: false,
          error: 'يجب تسجيل الدخول أولاً',
        ));
        return;
      }
      
      // إذا توفّر conversationId نختصر الطريق
      if (conversationId != null && conversationId.isNotEmpty) {
        final conversation = await _chatService.getConversation(conversationId);
        if (conversation != null) {
          _currentConversationId = conversation['id'];
          final messages = await _chatService.getMessages(
            conversationId: _currentConversationId!,
          );
          await _chatService.markMessagesAsRead(
            conversationId: _currentConversationId!,
            userId: currentUser.id,
          );
          _subscribeToMessages();

          // معلومات الطرف الآخر
          final isCurrentBuyer = conversation['buyer_id'] == currentUser.id;
          final otherMap = isCurrentBuyer ? conversation['seller'] : conversation['buyer'];
          final otherName = (sellerName != null && sellerName.isNotEmpty)
              ? sellerName
              : (otherMap?['full_name'] ?? otherMap?['display_name'] ?? otherMap?['name'])?.toString() ?? 'User';
          final otherAvatar = (otherMap?['avatar_url'] ?? otherMap?['photo_url'] ?? otherMap?['picture'])?.toString();
          final otherId = (isCurrentBuyer ? conversation['seller_id'] : conversation['buyer_id'])?.toString();
          final resolvedCarTitle = carTitle ?? conversation['car']?['title']?.toString();

          emit(state.copyWith(
            isLoading: false,
            conversationId: _currentConversationId,
            conversation: conversation,
            messages: messages,
            currentUserId: currentUser.id,
            otherUserId: otherId,
            otherUserName: otherName,
            otherUserAvatar: otherAvatar,
            carTitle: resolvedCarTitle,
          ));
          return;
        }
        // في حال لم نجد المحادثة، نكمل بالمسار العادي أدناه
      }

      if (sellerId == null || carId == null) {
        emit(state.copyWith(
          isLoading: false,
          error: 'معلومات البائع أو السيارة غير متوفرة',
        ));
        return;
      }
      
      // sellerId هنا تم تمريره كـ otherUserId (الطرف الآخر)
      final otherUserId = sellerId;

      // تحديد أدوار buyer/seller بالاعتماد على مالك السيارة
      String computedSellerId = otherUserId;
      String computedBuyerId = currentUser.id;
      String? resolvedCarTitle = carTitle;

      try {
        final car = await SupabaseService.client
            .from('cars')
            .select('user_id, title')
            .eq('id', carId)
            .maybeSingle();
        final carOwnerId = car?['user_id']?.toString();
        if (carOwnerId != null) {
          // إذا كان المستخدم الحالي هو مالك السيارة فهو البائع
          if (carOwnerId == currentUser.id) {
            computedSellerId = currentUser.id;
            computedBuyerId = otherUserId;
          } else {
            computedSellerId = carOwnerId;
            computedBuyerId = currentUser.id;
          }
          resolvedCarTitle ??= car?['title']?.toString();
        }
      } catch (_) {
        // في حال فشل جلب السيارة، نُكمل بالقيم الافتراضية أعلاه
      }

      // منع المستخدم من محادثة نفسه بعد تحديد الأدوار
      if (computedSellerId == computedBuyerId) {
        emit(state.copyWith(
          isLoading: false,
          error: 'لا يمكنك محادثة نفسك',
        ));
        return;
      }

      // إنشاء أو جلب المحادثة بالأدوار الصحيحة
      final conversation = await _chatService.getOrCreateConversation(
        carId: carId,
        buyerId: computedBuyerId,
        sellerId: computedSellerId,
      );
      
      if (conversation == null) {
        emit(state.copyWith(
          isLoading: false,
          error: 'فشل في إنشاء المحادثة',
        ));
        return;
      }
      
      _currentConversationId = conversation['id'];
      
      // جلب الرسائل السابقة
      final messages = await _chatService.getMessages(
        conversationId: _currentConversationId!,
      );
      
      // تحديد الرسائل كمقروءة
      await _chatService.markMessagesAsRead(
        conversationId: _currentConversationId!,
        userId: currentUser.id,
      );
      
      // الاشتراك في تحديثات الرسائل
      _subscribeToMessages();
      
      // تحديد اسم وصورة الطرف الآخر
      String? otherName = sellerName;
      final isCurrentBuyer = conversation['buyer_id'] == currentUser.id;
      final otherMap = isCurrentBuyer ? conversation['seller'] : conversation['buyer'];
      if (otherName == null || otherName.isEmpty) {
        otherName = (otherMap?['full_name'] ?? otherMap?['display_name'] ?? otherMap?['name'])?.toString() ?? 'User';
      }
      final otherAvatar = (otherMap?['avatar_url'] ?? otherMap?['photo_url'] ?? otherMap?['picture'])?.toString();

      // تحديد معرف الطرف الآخر
      final otherId = (isCurrentBuyer ? conversation['seller_id'] : conversation['buyer_id'])?.toString();

      emit(state.copyWith(
        isLoading: false,
        conversationId: _currentConversationId,
        conversation: conversation,
        messages: messages,
        currentUserId: currentUser.id,
        otherUserId: otherId,
        otherUserName: otherName,
        otherUserAvatar: otherAvatar,
        carTitle: resolvedCarTitle,
      ));
    } catch (e) {
      print('❌ Error initializing conversation: $e');
      emit(state.copyWith(
        isLoading: false,
        error: 'حدث خطأ: $e',
      ));
    }
  }
  
  /// الاشتراك في رسائل المحادثة
  void _subscribeToMessages() {
    if (_currentConversationId == null) return;
    
    _messagesSubscription?.unsubscribe();
    
    _messagesSubscription = _chatService.subscribeToConversation(
      conversationId: _currentConversationId!,
      onNewMessage: (message) {
        // إذا كانت الرسالة موجودة بنفس المعرف، تجاهلها
        final existsById = state.messages.any((m) => m['id'] == message['id']);
        if (existsById) return;

        // إزالة أي رسالة محلية معلّقة مطابقة (لتجنب التكرار)
        bool isLocalPending(Map<String, dynamic> m) {
          final isLocal = m['id']?.toString().startsWith('local_') == true;
          return isLocal &&
              m['message_text'] == message['message_text'] &&
              m['sender_id'] == message['sender_id'];
        }
        final filtered = state.messages.where((m) => !isLocalPending(m)).toList();
        final updatedMessages = [...filtered, message];
        emit(state.copyWith(messages: updatedMessages));
      },
      onMessageUpdate: (message) {
        // تحديث الرسالة إذا كانت موجودة، وإلا إضافتها
        final idx = state.messages.indexWhere((m) => m['id'] == message['id']);
        if (idx != -1) {
          final list = List<Map<String, dynamic>>.from(state.messages);
          list[idx] = message;
          emit(state.copyWith(messages: list));
        } else {
          emit(state.copyWith(messages: [...state.messages, message]));
        }
      },
    );
  }
  
  /// إرسال رسالة
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    if (_currentConversationId == null || state.currentUserId == null) return;
    
    emit(state.copyWith(isSending: true));
    // أضف رسالة متفائلة محليًا لتحسين الاستجابة البصرية
    final localId = 'local_${DateTime.now().microsecondsSinceEpoch}';
    final optimistic = {
      'id': localId,
      'conversation_id': _currentConversationId,
      'sender_id': state.currentUserId,
      'message_text': text.trim(),
      'message_type': 'text',
      'attachments': <String>[],
      'created_at': DateTime.now().toIso8601String(),
      'sender': {
        'id': state.currentUserId,
      },
    };
    emit(state.copyWith(messages: [...state.messages, optimistic]));
    
    try {
      final message = await _chatService.sendMessage(
        conversationId: _currentConversationId!,
        senderId: state.currentUserId!,
        messageText: text.trim(),
      );
      
      // إذا نجح الإرسال وأعد لنا الخادم الرسالة، استبدل المحلية بها فورًا
      if (message != null) {
        final list = state.messages.map((m) => m['id'] == localId ? message : m).toList();
        emit(state.copyWith(messages: list, isSending: false));
      } else {
        emit(state.copyWith(isSending: false));
      }
    } catch (e) {
      print('❌ Error sending message: $e');
      emit(state.copyWith(
        isSending: false,
        error: 'فشل إرسال الرسالة',
      ));
    }
  }
  
  /// تحميل المزيد من الرسائل (للتصفح)
  Future<void> loadMoreMessages() async {
    if (_currentConversationId == null || state.isLoadingMore) return;
    
    emit(state.copyWith(isLoadingMore: true));
    
    try {
      final olderMessages = await _chatService.getMessages(
        conversationId: _currentConversationId!,
        offset: state.messages.length,
      );
      
      if (olderMessages.isNotEmpty) {
        final updatedMessages = [...olderMessages, ...state.messages];
        emit(state.copyWith(
          messages: updatedMessages,
          isLoadingMore: false,
        ));
      } else {
        emit(state.copyWith(
          isLoadingMore: false,
          hasMoreMessages: false,
        ));
      }
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }
  
  @override
  Future<void> close() {
    _messagesSubscription?.unsubscribe();
    return super.close();
  }
}

// ==================== Chat State ====================
class ChatState {
  final bool isLoading;
  final bool isSending;
  final bool isLoadingMore;
  final bool hasMoreMessages;
  final String? error;
  final String? conversationId;
  final Map<String, dynamic>? conversation;
  final List<Map<String, dynamic>> messages;
  final String? currentUserId;
  final String? otherUserId;
  final String? otherUserName;
  final String? otherUserAvatar;
  final String? carTitle;
  
  const ChatState({
    this.isLoading = false,
    this.isSending = false,
    this.isLoadingMore = false,
    this.hasMoreMessages = true,
    this.error,
    this.conversationId,
    this.conversation,
    this.messages = const [],
    this.currentUserId,
    this.otherUserId,
    this.otherUserName,
    this.otherUserAvatar,
    this.carTitle,
  });
  
  ChatState copyWith({
    bool? isLoading,
    bool? isSending,
    bool? isLoadingMore,
    bool? hasMoreMessages,
    String? error,
    String? conversationId,
    Map<String, dynamic>? conversation,
    List<Map<String, dynamic>>? messages,
    String? currentUserId,
    String? otherUserId,
    String? otherUserName,
    String? otherUserAvatar,
    String? carTitle,
  }) {
    return ChatState(
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMoreMessages: hasMoreMessages ?? this.hasMoreMessages,
      error: error,
      conversationId: conversationId ?? this.conversationId,
      conversation: conversation ?? this.conversation,
      messages: messages ?? this.messages,
      currentUserId: currentUserId ?? this.currentUserId,
      otherUserId: otherUserId ?? this.otherUserId,
      otherUserName: otherUserName ?? this.otherUserName,
      otherUserAvatar: otherUserAvatar ?? this.otherUserAvatar,
      carTitle: carTitle ?? this.carTitle,
    );
  }
}
