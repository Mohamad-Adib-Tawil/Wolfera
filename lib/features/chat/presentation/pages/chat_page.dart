import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/features/chat/presentation/widgets/chat_app_bar.dart';
import '../widgets/chat_text_field.dart';
import '../widgets/messages_list_view_widget.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ChatAppbar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          5.verticalSpace,
          const Expanded(
            child: MessagesListViewWidget(),
          ),
          const ChatTextField(),
          5.verticalSpace,
        ],
      ),
    );
  }
}
