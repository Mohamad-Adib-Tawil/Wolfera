import 'package:flutter/material.dart';
import 'chat_bubble_item_widget.dart';
import 'date_time_widget_message_item.dart';

class MessageItemWidget extends StatelessWidget {
  const MessageItemWidget(
      {super.key, required this.isCurrent, required this.isTimeShow});
  final bool isCurrent;
  final bool isTimeShow;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isTimeShow ? const DateTimeWidgetMessageItem() : const SizedBox(),
        Row(
          mainAxisAlignment:
              isCurrent ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment:
              isCurrent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            ChatBubbleItemWidget(isCurrent: isCurrent),
          ],
        ),
      ],
    );
  }
}
