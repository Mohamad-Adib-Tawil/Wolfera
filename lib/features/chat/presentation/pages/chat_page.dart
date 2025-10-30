import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/features/chat/presentation/widgets/chat_app_bar.dart';
import 'package:wolfera/features/app/presentation/widgets/animations/delayed_fade_slide.dart';
import '../widgets/chat_text_field.dart';
import '../widgets/messages_list_view_widget.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  static bool _didAnimateOnce = false;
  late final bool _shouldAnimateEntrance;

  @override
  void initState() {
    _shouldAnimateEntrance = !_didAnimateOnce;
    _didAnimateOnce = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final messages = const Expanded(child: MessagesListViewWidget());
    final input = const ChatTextField();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: _shouldAnimateEntrance
            ? const DelayedFadeSlide(
                delay: Duration(milliseconds: 80),
                duration: Duration(milliseconds: 1000),
                beginOffset: Offset(0, -0.24),
                child: ChatAppbar(),
              )
            : const ChatAppbar(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          5.verticalSpace,
          _shouldAnimateEntrance
              ? DelayedFadeSlide(
                  delay: const Duration(milliseconds: 220),
                  duration: const Duration(milliseconds: 1000),
                  beginOffset: const Offset(-0.24, 0),
                  child: messages,
                )
              : messages,
          _shouldAnimateEntrance
              ? DelayedFadeSlide(
                  delay: const Duration(milliseconds: 340),
                  duration: const Duration(milliseconds: 1000),
                  beginOffset: const Offset(0, 0.24),
                  child: input,
                )
              : input,
          5.verticalSpace,
        ],
      ),
    );
  }
}
