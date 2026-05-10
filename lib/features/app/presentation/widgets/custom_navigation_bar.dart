import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wolfera/services/chat_service.dart';
import 'package:wolfera/services/chat_route_tracker.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/features/app/presentation/widgets/nav_bar_item.dart';
import 'package:wolfera/generated/assets.dart';
import 'package:wolfera/generated/locale_keys.g.dart';

class CustomNavigationBar extends StatefulWidget {
  final StatefulNavigationShell child;

  const CustomNavigationBar({super.key, required this.child});

  @override
  // ignore: library_private_types_in_public_api
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  int selectedIndex = 0;
  int _chatUnread = 0;
  RealtimeChannel? _userConvChannel;
  final _chatService = GetIt.I<ChatService>();

  void _onChatRouteChange() {
    // Whenever user enters/exits a chat, recalc unread (useful right after leaving)
    _refreshUnread();
  }

  void _onIncomingMessage() {
    // When a push 'new_message' arrives, refresh unread badge
    _refreshUnread();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    // Removed unused slide animation tween to reduce lints

    _initUnreadBadge();
    // Listen to chat route changes to refresh badge when leaving a chat
    ChatRouteTracker.currentConversationId.addListener(_onChatRouteChange);
    // Listen to push incoming message ticks to update unread immediately
    ChatRouteTracker.incomingMessageTick.addListener(_onIncomingMessage);
  }

  @override
  void dispose() {
    _controller.dispose();
    _userConvChannel?.unsubscribe();
    ChatRouteTracker.currentConversationId.removeListener(_onChatRouteChange);
    ChatRouteTracker.incomingMessageTick.removeListener(_onIncomingMessage);
    super.dispose();
  }

  void _animateCursor(int index) {
    setState(() {
      selectedIndex = index;
    });
    _controller.reset();
    _controller.forward();
    widget.child.goBranch(index);
  }

  Future<void> _initUnreadBadge() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        return;
      }
      // Initial total unread
      final total = await _chatService.getUnreadCount(userId);
      if (mounted) setState(() => _chatUnread = total);

      // Subscribe to conversation changes and recalc total
      _userConvChannel?.unsubscribe();
      _userConvChannel = _chatService.subscribeToUserConversations(
        userId: userId,
        onConversationUpdate: (_) async {
          await _refreshUnread();
        },
      );
    } catch (e) {
      debugPrint('Unread badge init error: $e');
    }
  }

  Future<void> _refreshUnread() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        return;
      }
      final t = await _chatService.getUnreadCount(userId);
      if (mounted) setState(() => _chatUnread = t);
    } catch (e) {
      debugPrint('Unread badge refresh error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78.h,
      width: double.infinity,
      padding: EdgeInsetsDirectional.only(
        start: 6.w,
        end: 6.w,
        top: 8.h,
        bottom: 6.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.blackLight,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.r),
          topRight: Radius.circular(8.r),
        ),
        border: Border(
          top: BorderSide(color: AppColors.white.withValues(alpha: 0.08)),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.22),
            blurRadius: 18,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: NavBarItem(
              title: LocaleKeys.home,
              svgAsset: Assets.svgNavHome,
              isSelected: widget.child.currentIndex == 0,
              onTap: () => _animateCursor(0),
            ),
          ),
          Expanded(
            child: NavBarItem(
              title: LocaleKeys.search,
              svgAsset: Assets.svgNavSearch,
              isSelected: widget.child.currentIndex == 1,
              onTap: () => _animateCursor(1),
            ),
          ),
          Expanded(
            child: NavBarItem(
              title: 'nav_my_cars_short',
              svgAsset: 'assets/svg/nav_my_cars.svg',
              isSelected: widget.child.currentIndex == 2,
              onTap: () => _animateCursor(2),
            ),
          ),
          Expanded(
            child: NavBarItem(
              title: 'car_stores',
              svgAsset: 'assets/svg/nav_store.svg',
              isSelected: widget.child.currentIndex == 3,
              onTap: () => _animateCursor(3),
            ),
          ),
          Expanded(
            child: NavBarItem(
              title: 'nav_favorite_short',
              svgAsset: Assets.svgNavFavorite,
              isSelected: widget.child.currentIndex == 4,
              onTap: () => _animateCursor(4),
            ),
          ),
          Expanded(
            child: NavBarItem(
              title: LocaleKeys.chat,
              svgAsset: Assets.svgNavChat,
              isSelected: widget.child.currentIndex == 5,
              onTap: () => _animateCursor(5),
              badgeCount: _chatUnread,
            ),
          ),
        ],
      ),
    );
  }
}
