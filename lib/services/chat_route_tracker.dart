import 'package:flutter/foundation.dart';

/// Tracks current chat screen to suppress notifications for the open conversation.
class ChatRouteTracker {
  ChatRouteTracker._();

  static final ValueNotifier<String?> currentConversationId =
      ValueNotifier<String?>(null);

  // Notifies listeners when an incoming message is received (e.g., FCM),
  // so UI can refresh unread counters immediately.
  static final ValueNotifier<int> incomingMessageTick =
      ValueNotifier<int>(0);

  static void enter(String conversationId) {
    currentConversationId.value = conversationId;
  }

  static void exit() {
    currentConversationId.value = null;
  }

  static void notifyIncomingMessage() {
    incomingMessageTick.value = incomingMessageTick.value + 1;
  }
}
