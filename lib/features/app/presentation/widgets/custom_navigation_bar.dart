import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wolfera/services/chat_service.dart';
import 'package:wolfera/services/chat_route_tracker.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/features/app/presentation/widgets/nav_bar_item.dart';
import 'package:wolfera/features/app/presentation/widgets/nav_bar_item_circular.dart';
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
    print('🔍 [DEBUG] _onChatRouteChange: Chat route changed, refreshing unread count');
    _refreshUnread();
  }

  void _onIncomingMessage() {
    // When a push 'new_message' arrives, refresh unread badge
    print('🔍 [DEBUG] _onIncomingMessage: Incoming message tick, refreshing unread count');
    _refreshUnread();
  }

  @override
  void initState() {
    super.initState();
    print('🔍 [DEBUG] CustomNavigationBar initState called');
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    // Removed unused slide animation tween to reduce lints

    print('🔍 [DEBUG] About to call _initUnreadBadge');
    _initUnreadBadge();
    // Listen to chat route changes to refresh badge when leaving a chat
    ChatRouteTracker.currentConversationId.addListener(_onChatRouteChange);
    // Listen to push incoming message ticks to update unread immediately
    ChatRouteTracker.incomingMessageTick.addListener(_onIncomingMessage);
    print('🔍 [DEBUG] CustomNavigationBar initState completed');
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
        print('🔍 [DEBUG] _initUnreadBadge: No user logged in');
        return;
      }
      print('🔍 [DEBUG] _initUnreadBadge: Getting initial unread count for $userId');
      // Initial total unread
      final total = await _chatService.getUnreadCount(userId);
      print('🔍 [DEBUG] _initUnreadBadge: Initial unread count = $total');
      if (mounted) setState(() => _chatUnread = total);

      // Subscribe to conversation changes and recalc total
      _userConvChannel?.unsubscribe();
      _userConvChannel = _chatService.subscribeToUserConversations(
        userId: userId,
        onConversationUpdate: (_) async {
          print('🔍 [DEBUG] _initUnreadBadge: Conversation update received, refreshing...');
          await _refreshUnread();
        },
      );
    } catch (e) {
      print('❌ [DEBUG] _initUnreadBadge error: $e');
    }
  }

  Future<void> _refreshUnread() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        print('🔍 [DEBUG] _refreshUnread: No user logged in');
        return;
      }
      print('🔍 [DEBUG] _refreshUnread: Getting updated unread count for $userId');
      final t = await _chatService.getUnreadCount(userId);
      print('🔍 [DEBUG] _refreshUnread: Updated unread count = $t, current = $_chatUnread');
      if (mounted) setState(() => _chatUnread = t);
    } catch (e) {
      print('❌ [DEBUG] _refreshUnread error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      width: 413.w,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5), topRight: Radius.circular(5)),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 65.h,
              decoration: const BoxDecoration(
                color: AppColors.blackLight,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  NavBarItem(
                    title: LocaleKeys.home,
                    svgAsset: Assets.svgNavHome,
                    isSelected: widget.child.currentIndex == 0,
                    onTap: () => _animateCursor(0),
                  ),
                  NavBarItem(
                    title: LocaleKeys.search,
                    svgAsset: Assets.svgNavSearch,
                    isSelected: widget.child.currentIndex == 1,
                    onTap: () => _animateCursor(1),
                  ),
                  40.horizontalSpace,
                  NavBarItem(
                    title: LocaleKeys.favorite,
                    svgAsset: Assets.svgNavFavorite,
                    isSelected: widget.child.currentIndex == 3,
                    onTap: () => _animateCursor(3),
                  ),
                  NavBarItem(
                    title: "Chat",
                    svgAsset: Assets.svgNavChat,
                    isSelected: widget.child.currentIndex == 4,
                    onTap: () {
                      print('🔍 [DEBUG] Chat tab tapped, current _chatUnread = $_chatUnread');
                      _animateCursor(4);
                    },
                    badgeCount: _chatUnread,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Center(
              child: NavBarItemCircular(
                svgAsset: Assets.svgNavCarSell,
                isSelected: widget.child.currentIndex == 2,
                onTap: () => _animateCursor(2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
