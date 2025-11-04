import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/services/chat_service.dart';
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
    final messageType = (message['message_type'] ?? 'text').toString();
    final messageId = message['id']?.toString();
    
    // عرض رسائل النظام في الوسط بشكل مميز
    if (messageType == 'system') {
      return Column(
        children: [
          if (isTimeShow && messageTime != null)
            DateTimeWidgetMessageItem(dateTime: messageTime)
          else
            const SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFEDEEF3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: AppText(
                (message['message_text'] ?? '').toString(),
                translation: false,
                style: const TextStyle(color: Colors.black87, fontSize: 13),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        if (isTimeShow && messageTime != null)
          DateTimeWidgetMessageItem(dateTime: messageTime)
        else
          const SizedBox.shrink(),
        GestureDetector(
          onLongPress: !isCurrent || messageId == null
              ? null
              : () async {
                  final ok = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Delete message?'),
                          content: const Text('This message will be marked as deleted for both sides.'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                            TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
                          ],
                        ),
                      ) ??
                      false;
                  if (!ok) return;
                  await GetIt.I<ChatService>().deleteMessage(messageId: messageId);
                },
          child: Row(
            mainAxisAlignment:
                isCurrent ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment:
                isCurrent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              ChatBubbleItemWidget(
                isCurrent: isCurrent,
                messageText: (message['message_text'] ?? '').toString(),
                messageTime: messageTime,
                senderName: message['sender']?['full_name'] ?? '',
                senderAvatar: message['sender']?['avatar_url'],
                isDeleted: messageType == 'deleted',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
