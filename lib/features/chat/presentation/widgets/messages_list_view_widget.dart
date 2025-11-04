import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/chat/presentation/manager/chat_cubit.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'message_item_widget.dart';

class MessagesListViewWidget extends StatefulWidget {
  const MessagesListViewWidget({super.key});

  @override
  State<MessagesListViewWidget> createState() => _MessagesListViewWidgetState();
}

class _MessagesListViewWidgetState extends State<MessagesListViewWidget> {
  final ScrollController _scrollController = ScrollController();
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {
        // عند وصول رسالة جديدة، انتقل لأسفل
        if (_scrollController.hasClients && state.messages.isNotEmpty) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      },
      builder: (context, state) {
        if (state.messages.isEmpty) {
          return Center(
            child: AppText(
              'ابدأ المحادثة...',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16.sp,
              ),
            ),
          );
        }
        
        return ListView.separated(
          controller: _scrollController,
          reverse: true,  // لعرض آخر رسالة في الأسفل
          padding: HWEdgeInsets.only(left: 12, right: 12, top: 10, bottom: 12),
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final message = state.messages[state.messages.length - 1 - index];
            final isCurrentUser = message['sender_id'] == state.currentUserId;
            final previousIndex = state.messages.length - index;
            final showTime = previousIndex < state.messages.length && 
                             _shouldShowTime(index, state.messages);
            
            return MessageItemWidget(
              message: message,
              isCurrent: isCurrentUser,
              isTimeShow: showTime,
            );
          },
          separatorBuilder: (context, index) {
            return 10.verticalSpace;
          },
          itemCount: state.messages.length,
        );
      },
    );
  }
  
  bool _shouldShowTime(int index, List<Map<String, dynamic>> messages) {
    // اعرض تاريخ اليوم لأحدث مجموعة رسائل دائمًا
    if (index == 0) return true;
    if (index >= messages.length) return false;

    // بما أن القائمة معكوسة، احسب المؤشرات الفعلية
    final currentIdx = messages.length - 1 - index;
    final prevIdx = currentIdx + 1;
    if (prevIdx >= messages.length) return true;

    final current = messages[currentIdx]['created_at'];
    final previous = messages[prevIdx]['created_at'];
    if (current == null || previous == null) return false;

    final currentTime = DateTime.tryParse(current.toString());
    final previousTime = DateTime.tryParse(previous.toString());
    if (currentTime == null || previousTime == null) return false;

    // اعرض الفاصل عند تغير اليوم التقويمي
    final isDifferentDay = currentTime.year != previousTime.year ||
        currentTime.month != previousTime.month ||
        currentTime.day != previousTime.day;
    return isDifferentDay;
  }
}
