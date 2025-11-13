import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_loader_widget/app_loader.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/chat/presentation/widgets/chat_item.dart';
import 'package:wolfera/services/chat_service.dart';
import 'package:wolfera/services/supabase_service.dart';

class ArchivedConversationsPage extends StatefulWidget {
  const ArchivedConversationsPage({super.key});

  @override
  State<ArchivedConversationsPage> createState() =>
      _ArchivedConversationsPageState();
}

class _ArchivedConversationsPageState extends State<ArchivedConversationsPage> {
  final _chatService = GetIt.I<ChatService>();
  bool _isLoading = true;
  List<Map<String, dynamic>> _archivedConversations = [];

  @override
  void initState() {
    super.initState();
    _loadArchivedConversations();
  }

  Future<void> _loadArchivedConversations() async {
    final user = SupabaseService.currentUser;
    if (user == null) {
      setState(() {
        _isLoading = false;
        _archivedConversations = [];
      });
      return;
    }

    try {
      setState(() => _isLoading = true);

      final list = await _chatService.getArchivedConversations(user.id);
      final filtered =
          list.where((c) => c['buyer_id'] != c['seller_id']).toList();

      if (mounted) {
        setState(() {
          _archivedConversations = filtered;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Error loading archived conversations: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load archived conversations'),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: _loadArchivedConversations,
            ),
          ),
        );
      }
    }
  }

  Future<void> _confirmRestore(Map<String, dynamic> conv) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: const Color(0xFF1E1F24),
            title: Text(
              'restore_conversation_q'.tr(),
              style: const TextStyle(color: Colors.white),
            ),
            content: Text(
              'restore_conversation_body'.tr(),
              style: const TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text('cancel'.tr()),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(
                  'restore'.tr(),
                  style: const TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed) return;

    final id = conv['id']?.toString();
    if (id == null) return;

    final success = await _chatService.restoreConversation(id);
    if (success) {
      setState(() {
        _archivedConversations.removeWhere((e) => e['id'] == id);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('conversation_restored'.tr())),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('failed_to_restore_conversation'.tr())),
        );
      }
    }
  }

  Future<void> _confirmDelete(Map<String, dynamic> conv) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: const Color(0xFF1E1F24),
            title: Text(
              'delete_conversation_permanently_q'.tr(),
              style: const TextStyle(color: Colors.white),
            ),
            content: Text(
              'delete_conversation_permanently_body'.tr(),
              style: const TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text('cancel'.tr()),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(
                  'delete_permanently'.tr(),
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed) return;

    final id = conv['id']?.toString();
    if (id == null) return;

    final success = await _chatService.deleteConversation(id);
    if (success) {
      setState(() {
        _archivedConversations.removeWhere((e) => e['id'] == id);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('conversation_deleted_permanently'.tr())),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('failed_to_delete_conversation'.tr())),
        );
      }
    }
  }

  // Keep the old method for backward compatibility with bottom sheet
  Future<void> _restoreConversation(Map<String, dynamic> conv) async {
    await _confirmRestore(conv);
  }

  Future<void> _deleteConversationPermanently(Map<String, dynamic> conv) async {
    await _confirmDelete(conv);
  }

  void _showConversationActions(Map<String, dynamic> conv) {
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
                  AppText(
                    'archived_conversation_actions'.tr(),
                    style: context.textTheme.titleMedium.s18.xb,
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close, color: Colors.white70),
                  )
                ],
              ),
              10.verticalSpace,
              ListTile(
                leading: const Icon(Icons.restore, color: AppColors.primary),
                title: AppText('restore_conversation'.tr()),
                onTap: () {
                  Navigator.pop(ctx);
                  _restoreConversation(conv);
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.delete_forever, color: Colors.redAccent),
                title: AppText('delete_permanently'.tr()),
                onTap: () {
                  Navigator.pop(ctx);
                  _deleteConversationPermanently(conv);
                },
              ),
              6.verticalSpace,
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackLight,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: AppText(
          'archived_conversations'.tr(),
          style: context.textTheme.bodyMedium.s20.m,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadArchivedConversations,
        child: Padding(
          padding: HWEdgeInsets.only(left: 20, right: 20, top: 10),
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: AppLoader());
    }

    if (_archivedConversations.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              169.verticalSpace,
              Container(
                padding: HWEdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.12),
                      AppColors.primary.withOpacity(0.06),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.25),
                    width: 1.2,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.archive_outlined,
                      size: 64.sp,
                      color: AppColors.primary.withOpacity(0.7),
                    ),
                    16.verticalSpace,
                    AppText(
                      'no_archived_conversations'.tr(),
                      style: context.textTheme.titleMedium?.s18.xb
                          .withColor(Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    8.verticalSpace,
                    AppText(
                      'no_archived_conversations_subtitle'.tr(),
                      style: context.textTheme.bodyMedium
                          ?.withColor(Colors.white70),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              200.verticalSpace,
            ],
          ),
        ),
      );
    }

    final list = ListView.builder(
      itemCount: _archivedConversations.length,
      shrinkWrap: true,
      padding: HWEdgeInsets.only(bottom: 25),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final conv = _archivedConversations[index];
        final me = SupabaseService.currentUser!.id;
        final isBuyer = conv['buyer_id'] == me;
        final other = isBuyer ? conv['seller'] : conv['buyer'];
        final otherName = other != null
            ? (other['full_name'] ?? other['display_name'] ?? other['name'])
                ?.toString()
            : 'user'.tr();
        final otherAvatar = other != null
            ? (other['avatar_url'] ?? other['photo_url'] ?? other['picture'])
                ?.toString()
            : null;
        final subtitle = (conv['last_message'] ?? '').toString();
        final timeText = (conv['last_message_at'] ??
                conv['updated_at'] ??
                conv['created_at'])
            ?.toString();

        return Padding(
          padding: HWEdgeInsets.only(top: index == 0 ? 0 : 25),
          child: Slidable(
            key: ValueKey('archived-conv-${conv['id']}'),
            startActionPane: ActionPane(
              motion: const StretchMotion(),
              extentRatio: 0.46,
              children: [
                SlidableAction(
                  onPressed: (_) => _confirmRestore(conv),
                  backgroundColor: AppColors.primary.withValues(alpha: 0.18),
                  foregroundColor: AppColors.primary,
                  icon: Icons.restore,
                  label: 'restore'.tr(),
                  borderRadius: BorderRadius.circular(12),
                ),
                SlidableAction(
                  onPressed: (_) => _confirmDelete(conv),
                  backgroundColor: const Color(0xFF3A1F1F),
                  foregroundColor: Colors.redAccent,
                  icon: Icons.delete_forever,
                  label: 'delete_permanently_short'.tr(),
                  borderRadius: BorderRadius.circular(12),
                ),
              ],
            ),
            endActionPane: ActionPane(
              motion: const StretchMotion(),
              extentRatio: 0.46,
              children: [
                SlidableAction(
                  onPressed: (_) => _confirmRestore(conv),
                  backgroundColor: AppColors.primary.withValues(alpha: 0.18),
                  foregroundColor: AppColors.primary,
                  icon: Icons.restore,
                  label: 'restore'.tr(),
                  borderRadius: BorderRadius.circular(12),
                ),
                SlidableAction(
                  onPressed: (_) => _confirmDelete(conv),
                  backgroundColor: const Color(0xFF3A1F1F),
                  foregroundColor: Colors.redAccent,
                  icon: Icons.delete_forever,
                  label: 'delete_permanently_short'.tr(),
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
              unreadCount: 0, // Archived conversations don't show unread count
              onTap: () => _confirmRestore(conv),
              onLongPress: () => _showConversationActions(conv),
            ),
          ),
        );
      },
    );

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: list,
    );
  }
}
