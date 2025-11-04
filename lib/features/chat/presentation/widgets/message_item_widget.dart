import 'package:flutter/material.dart';
import 'chat_bubble_item_widget.dart';
import 'date_time_widget_message_item.dart';

class MessageItemWidget extends StatelessWidget {
  const MessageItemWidget({
    super.key,
    required this.message,
    required this.isCurrent,
    required this.isTimeShow,
  });
  
  final Map<String, dynamic> message;
  final bool isCurrent;
  final bool isTimeShow;
  
  @override
  Widget build(BuildContext context) {
    final createdAt = message['created_at'];
    final messageTime = createdAt != null
        ? DateTime.tryParse(createdAt.toString())
        : null;
    
    return Column(
      children: [
        if (isTimeShow && messageTime != null)
          DateTimeWidgetMessageItem(dateTime: messageTime)
        else
          const SizedBox.shrink(),
        Row(
          mainAxisAlignment:
              isCurrent ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment:
              isCurrent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            ChatBubbleItemWidget(
              isCurrent: isCurrent,
              messageText: message['message_text'] ?? '',
              messageTime: messageTime,
              senderName: message['sender']?['full_name'] ?? '',
              senderAvatar: message['sender']?['avatar_url'],
            ),
          ],
        ),
      ],
    );
  }
}
