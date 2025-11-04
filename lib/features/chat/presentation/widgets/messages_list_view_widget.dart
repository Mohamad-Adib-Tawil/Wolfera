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
            final showTime = _shouldShowTime(index, state.messages);
            
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
    if (index >= messages.length) return false;

    // القائمة معكوسة visual (reverse: true) لكننا نأخذ الرسائل من الأحدث للأقدم
    // currentIdx: مؤشر الرسالة الحالية في ترتيب state.messages (الأقدم -> الأحدث)
    final currentIdx = messages.length - 1 - index;

    // نريد إظهار العنوان عند أول رسالة لكل يوم (مثل واتساب)
    // هذا يتحقق عندما تختلف يوم الرسالة الحالية عن الرسالة الأقدم منها في العرض (index+1)
    final olderIdx = currentIdx - 1; // في ترتيب state.messages

    final current = messages[currentIdx]['created_at'];
    if (current == null) return false;
    final currentTime = DateTime.tryParse(current.toString())?.toLocal();
    if (currentTime == null) return false;

    // إذا لا يوجد رسالة أقدم (نهاية القائمة بصريًا)، أعرض العنوان لهذا اليوم
    if (olderIdx < 0) return true;

    final older = messages[olderIdx]['created_at'];
    if (older == null) return true;
    final olderTime = DateTime.tryParse(older.toString())?.toLocal();
    if (olderTime == null) return true;

    final currentDay = DateTime(currentTime.year, currentTime.month, currentTime.day);
    final olderDay = DateTime(olderTime.year, olderTime.month, olderTime.day);
    return currentDay.year != olderDay.year ||
        currentDay.month != olderDay.month ||
        currentDay.day != olderDay.day;
  }
}
