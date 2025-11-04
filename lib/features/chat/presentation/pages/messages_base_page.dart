import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wolfera/core/config/routing/router.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/extensions/list.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_loader_widget/app_loader.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/chat/presentation/widgets/chat_empty_state_widget.dart';
import 'package:wolfera/features/chat/presentation/widgets/chat_item.dart';
import 'package:wolfera/services/chat_service.dart';
import 'package:wolfera/services/supabase_service.dart';

class MessagesBasePage extends StatefulWidget {
  const MessagesBasePage({super.key});

  @override
  State<MessagesBasePage> createState() => _MessagesBasePageState();
}

class _MessagesBasePageState extends State<MessagesBasePage> {
  // One-time entrance animation flag
  static bool _didAnimateOnce = false;
  late final bool _shouldAnimateEntrance;
  final _chatService = GetIt.I<ChatService>();
  RealtimeChannel? _sub;
  bool _isLoading = true;
  List<Map<String, dynamic>> _conversations = [];

  @override
  void initState() {
    super.initState();
    _shouldAnimateEntrance = !_didAnimateOnce;
    _didAnimateOnce = true;
    _loadConversations();
  }

  Future<void> _confirmClear(Map<String, dynamic> conv) async {
    final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Clear conversation?'),
            content: const Text('This will remove all messages and send a system notice to the other user.'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
              TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Clear', style: TextStyle(color: Colors.red))),
            ],
          ),
        ) ??
        false;
    if (!ok) return;
    final id = conv['id']?.toString();
    final actor = SupabaseService.currentUser?.id;
    if (id == null || actor == null) return;
    final success = await _chatService.clearConversation(conversationId: id, actorId: actor);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Conversation cleared')));
    }
  }

  void _showActionsSheet(Map<String, dynamic> conv) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1F24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      builder: (ctx) {
        return Padding(
          padding: HWEdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText('Conversation actions', translation: false, style: context.textTheme.titleMedium.s18.xb),
                  IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close, color: Colors.white70))
                ],
              ),
              10.verticalSpace,
              ListTile(
                leading: const Icon(Icons.archive_outlined, color: AppColors.primary),
                title: const AppText('Hide conversation', translation: false),
                onTap: () {
                  Navigator.pop(ctx);
                  _confirmArchive(conv);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cleaning_services_outlined, color: Colors.redAccent),
                title: const AppText('Clear conversation', translation: false),
                onTap: () {
                  Navigator.pop(ctx);
                  _confirmClear(conv);
                },
              ),
              6.verticalSpace,
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmArchive(Map<String, dynamic> conv) async {
    final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Hide conversation?'),
            content: const Text('This will hide the conversation from your list. You can still receive messages.'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
              TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Hide')),
            ],
          ),
        ) ??
        false;
    if (!ok) return;
    final id = conv['id']?.toString();
    if (id == null) return;
    final success = await _chatService.archiveConversation(id);
    if (success) {
      setState(() => _conversations.removeWhere((e) => e['id'] == id));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Conversation hidden')));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: AppColors.blackLight,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: _shouldAnimateEntrance
                ? const _DelayedFadeSlide(
                    delay: Duration(milliseconds: 80),
                    duration: Duration(milliseconds: 1000),
                    beginOffset: Offset(0, -0.24),
                    child: _AnimatedAppBar(),
                  )
                : appBar(context),
          ),
          body: Padding(
            padding: HWEdgeInsets.only(left: 20, right: 20, top: 10),
            child: _buildBody(),
          )),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: AppLoader());
    }
    if (_conversations.isNullOrEmpty) {
      return Column(
        children: [
          169.verticalSpace,
          _shouldAnimateEntrance
              ? const _DelayedFadeSlide(
                  delay: Duration(milliseconds: 220),
                  duration: Duration(milliseconds: 1000),
                  beginOffset: Offset(-0.24, 0),
                  child: ChatsEmptyStateWidget(),
                )
              : const ChatsEmptyStateWidget(),
        ],
      );
    }
    final list = ListView.builder(
      itemCount: _conversations.length,
      shrinkWrap: true,
      padding: HWEdgeInsets.only(bottom: 25),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final conv = _conversations[index];
        final me = SupabaseService.currentUser!.id;
        final isBuyer = conv['buyer_id'] == me;
        final other = isBuyer ? conv['seller'] : conv['buyer'];
        final otherName = other != null ? (other['full_name'] ?? other['display_name'] ?? other['name'])?.toString() : 'User';
        final otherAvatar = other != null ? (other['avatar_url'] ?? other['photo_url'] ?? other['picture'])?.toString() : null;
        final subtitle = (conv['last_message'] ?? '').toString();
        final timeText = (conv['last_message_at'] ?? conv['updated_at'] ?? conv['created_at'])?.toString();
        return Padding(
          padding: HWEdgeInsets.only(top: index == 0 ? 0 : 25),
          child: Slidable(
            key: ValueKey('conv-${conv['id']}'),
            startActionPane: ActionPane(
              motion: const StretchMotion(),
              extentRatio: 0.46,
              children: [
                SlidableAction(
                  onPressed: (_) => _confirmArchive(conv),
                  backgroundColor: AppColors.primary.withValues(alpha: 0.18),
                  foregroundColor: AppColors.primary,
                  icon: Icons.archive_outlined,
                  label: 'Hide',
                  borderRadius: BorderRadius.circular(12),
                ),
                SlidableAction(
                  onPressed: (_) => _confirmClear(conv),
                  backgroundColor: const Color(0xFF3A1F1F),
                  foregroundColor: Colors.redAccent,
                  icon: Icons.cleaning_services_outlined,
                  label: 'Clear',
                  borderRadius: BorderRadius.circular(12),
                ),
              ],
            ),
            endActionPane: ActionPane(
              motion: const StretchMotion(),
              extentRatio: 0.46,
              children: [
                SlidableAction(
                  onPressed: (_) => _confirmArchive(conv),
                  backgroundColor: AppColors.primary.withValues(alpha: 0.18),
                  foregroundColor: AppColors.primary,
                  icon: Icons.archive_outlined,
                  label: 'Hide',
                  borderRadius: BorderRadius.circular(12),
                ),
                SlidableAction(
                  onPressed: (_) => _confirmClear(conv),
                  backgroundColor: const Color(0xFF3A1F1F),
                  foregroundColor: Colors.redAccent,
                  icon: Icons.cleaning_services_outlined,
                  label: 'Clear',
                  borderRadius: BorderRadius.circular(12),
                ),
              ],
            ),
            child: ChatItem(
              index: index,
              title: otherName,
              subtitle: subtitle.isNotEmpty ? subtitle : null,
              avatarUrl: otherAvatar,
              timeText: timeText,
              onTap: () => _openConversation(
                conv,
                otherId: other?['id']?.toString(),
                otherName: otherName,
                otherAvatar: otherAvatar,
              ),
              onLongPress: () => _showActionsSheet(conv),
            ),
          ),
        );
      },
    );
    return _shouldAnimateEntrance
        ? _DelayedFadeSlide(
            delay: const Duration(milliseconds: 300),
            duration: const Duration(milliseconds: 1000),
            beginOffset: const Offset(-0.24, 0),
            child: list,
          )
        : list;
  }

  Future<void> _loadConversations() async {
    final user = SupabaseService.currentUser;
    if (user == null) {
      setState(() {
        _isLoading = false;
        _conversations = [];
      });
      return;
    }
    try {
      final list = await _chatService.getUserConversations(user.id);
      // استبعد المحادثات الخاطئة التي يكون فيها الطرفان نفس المستخدم
      final filtered = list.where((c) => c['buyer_id'] != c['seller_id']).toList();
      setState(() {
        _conversations = filtered;
        _isLoading = false;
      });
      _sub?.unsubscribe();
      _sub = _chatService.subscribeToUserConversations(
        userId: user.id,
        onConversationUpdate: (conv) {
          setState(() {
            // إذا أصبحت غير نشطة (مؤرشفة) احذفها من اللائحة
            if (conv['is_active'] != true) {
              _conversations.removeWhere((e) => e['id'] == conv['id']);
            } else {
              final i = _conversations.indexWhere((e) => e['id'] == conv['id']);
              if (i >= 0) {
                _conversations[i] = conv;
              } else {
                _conversations.insert(0, conv);
              }
            }
          });
        },
      );
    } catch (_) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _openConversation(Map<String, dynamic> conv, {String? otherId, String? otherName, String? otherAvatar}) {
    final me = SupabaseService.currentUser?.id;
    if (me == null) return;

    // إذا كانت المحادثة خاطئة (buyer == seller == me)، استخدم مالك السيارة كطرف آخر
    if ((conv['buyer_id'] == conv['seller_id']) && conv['car']?['user_id'] != null) {
      final carOwner = conv['car']['user_id']?.toString();
      if (carOwner != null && carOwner != me) {
        otherId = carOwner;
      }
    }

    if (otherId == null || otherId.isEmpty || otherId == me) {
      // لا نحاول فتح شات مع الذات
      return;
    }
    GRouter.router.pushNamed(
      GRouter.config.chatsRoutes.chatPage,
      extra: {
        'conversation_id': conv['id']?.toString(),
        'seller_id': otherId, // الطرف الآخر
        'seller_name': otherName,
        'seller_avatar': otherAvatar,
        'car_id': conv['car_id']?.toString(),
        'car_title': conv['car']?['title']?.toString(),
      },
    );
  }

  @override
  void dispose() {
    _sub?.unsubscribe();
    super.dispose();
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      title: AppText(
        "Messages",
        style: context.textTheme.bodyMedium.s20.m,
        translation: false,
      ),
    );
  }
}

// Animated wrapper for app bar content
class _AnimatedAppBar extends StatelessWidget {
  const _AnimatedAppBar();

  @override
  Widget build(BuildContext context) => AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: AppText(
          "Messages",
          style: context.textTheme.bodyMedium.s20.m,
        ),
      );
}

class _DelayedFadeSlide extends StatefulWidget {
  const _DelayedFadeSlide({
    required this.child,
    required this.delay,
    this.duration = const Duration(milliseconds: 820),
    this.beginOffset = const Offset(0, 0.08),
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset beginOffset;

  @override
  State<_DelayedFadeSlide> createState() => _DelayedFadeSlideState();
}

class _DelayedFadeSlideState extends State<_DelayedFadeSlide> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: widget.duration,
      curve: Curves.easeOutCubic,
      opacity: _visible ? 1 : 0,
      child: AnimatedSlide(
        duration: widget.duration,
        curve: Curves.easeOutCubic,
        offset: _visible ? Offset.zero : widget.beginOffset,
        child: widget.child,
      ),
    );
  }
}
