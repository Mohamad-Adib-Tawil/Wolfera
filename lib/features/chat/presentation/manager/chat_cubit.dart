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
      
      // تحديد اسم الطرف الآخر إن لم يتم تمريره
      String? otherName = sellerName;
      if (otherName == null || otherName.isEmpty) {
        final isCurrentBuyer = conversation['buyer_id'] == currentUser.id;
        final other = isCurrentBuyer ? conversation['seller'] : conversation['buyer'];
        otherName = (other?['full_name'] ?? other?['display_name'] ?? other?['name'])?.toString() ?? 'User';
      }

      emit(state.copyWith(
        isLoading: false,
        conversationId: _currentConversationId,
        conversation: conversation,
        messages: messages,
        currentUserId: currentUser.id,
        otherUserName: otherName,
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
    
    // إلغاء الاشتراك السابق
    _messagesSubscription?.unsubscribe();
    
    _messagesSubscription = _chatService.subscribeToConversation(
      conversationId: _currentConversationId!,
      onNewMessage: (message) {
        // إضافة الرسالة الجديدة
        final updatedMessages = [...state.messages, message];
        emit(state.copyWith(messages: updatedMessages));
        
        // تحديد كمقروءة إذا كانت من الطرف الآخر
        if (message['sender_id'] != state.currentUserId) {
          _chatService.markMessagesAsRead(
            conversationId: _currentConversationId!,
            userId: state.currentUserId!,
          );
        }
      },
      onMessageUpdate: (message) {
        // تحديث الرسالة الموجودة
        final updatedMessages = state.messages.map((m) {
          if (m['id'] == message['id']) {
            return message;
          }
          return m;
        }).toList();
        emit(state.copyWith(messages: updatedMessages));
      },
    );
  }
  
  /// إرسال رسالة
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    if (_currentConversationId == null || state.currentUserId == null) return;
    
    emit(state.copyWith(isSending: true));
    
    try {
      final message = await _chatService.sendMessage(
        conversationId: _currentConversationId!,
        senderId: state.currentUserId!,
        messageText: text.trim(),
      );
      
      if (message != null) {
        // الرسالة ستصل عبر Realtime
      }
      
      emit(state.copyWith(isSending: false));
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
  final String? otherUserName;
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
    this.otherUserName,
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
    String? otherUserName,
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
      otherUserName: otherUserName ?? this.otherUserName,
      carTitle: carTitle ?? this.carTitle,
    );
  }
}
