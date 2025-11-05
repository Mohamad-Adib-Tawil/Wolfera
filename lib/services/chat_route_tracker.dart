import 'package:flutter/foundation.dart';

/// Tracks current chat screen to suppress notifications for the open conversation.
class ChatRouteTracker {
  ChatRouteTracker._();

  static final ValueNotifier<String?> currentConversationId =
      ValueNotifier<String?>(null);

  static void enter(String conversationId) {
    currentConversationId.value = conversationId;
  }

  static void exit() {
    currentConversationId.value = null;
  }
}
