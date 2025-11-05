import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:wolfera/core/config/routing/router.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_loader_widget/app_loader.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/app/presentation/widgets/animations/delayed_fade_slide.dart';
import 'package:wolfera/features/notifications/presentation/manager/notifications_cubit.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  static bool _didAnimateOnce = false;
  late final bool _shouldAnimateEntrance;
  late final NotificationsCubit _notificationsCubit;

  @override
  void initState() {
    super.initState();
    _shouldAnimateEntrance = !_didAnimateOnce;
    _didAnimateOnce = true;
    _notificationsCubit = GetIt.I<NotificationsCubit>();
    // حمّل الإشعارات للعرض؛ سنقوم بتصفير العداد عند الرجوع للخلف
    _notificationsCubit.loadNotifications();
  }

  @override
  void dispose() {
    // عند الخروج من الصفحة، صفّر العداد أيضًا لأي إشعارات وصلت خلال التصفح
    _notificationsCubit.markAllAsRead();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _notificationsCubit,
      child: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          final all = state.notifications;
          final msgs = all.where((n) => (n['type']?.toString() ?? '') == 'new_message').toList();
          final general = all.where((n) => (n['type']?.toString() ?? '') != 'new_message').toList();

          Widget buildList(List<Map<String, dynamic>> items) {
            if (state.isLoading) {
              return const Center(child: AppLoader());
            }
            if (items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_off_outlined,
                      size: 80.sp,
                      color: AppColors.grey,
                    ),
                    16.verticalSpace,
                    AppText('no_notifications', style: context.textTheme.bodyLarge?.withColor(AppColors.grey)),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () => _notificationsCubit.loadNotifications(),
              child: ListView.builder(
                padding: HWEdgeInsets.symmetric(horizontal: 20, vertical: 20),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final notification = items[index];
                  return NotificationItemWidget(
                    notification: notification,
                    onTap: () => _handleNotificationTap(notification),
                    onDismiss: () => _notificationsCubit.deleteNotification(
                      notification['id'].toString(),
                    ),
                  );
                },
              ),
            );
          }

          return DefaultTabController(
            length: 2,
            child: Scaffold(
              backgroundColor: AppColors.blackLight,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                centerTitle: true,
                automaticallyImplyLeading: true,
                title: AppText('Notifications'.tr()),
                bottom: TabBar(
                  indicatorColor: AppColors.primary,
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.grey,
                  tabs: [
                    Tab(text: 'general'.tr()),
                    Tab(text: 'messages'.tr()),
                  ],
                ),
              ),
              body: _shouldAnimateEntrance
                  ? DelayedFadeSlide(
                      delay: const Duration(milliseconds: 260),
                      duration: const Duration(milliseconds: 1000),
                      beginOffset: const Offset(-0.24, 0),
                      child: TabBarView(
                        children: [
                          buildList(general),
                          buildList(msgs),
                        ],
                      ),
                    )
                  : TabBarView(
                      children: [
                        buildList(general),
                        buildList(msgs),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }

  void _handleNotificationTap(Map<String, dynamic> notification) {
    // تحديد كمقروء
    if (notification['read_at'] == null) {
      _notificationsCubit.markAsRead(notification['id'].toString());
    }
    
    // التنقل حسب نوع الإشعار
    final type = notification['type']?.toString();
    final data = notification['data'] ?? {};
    
    switch (type) {
      case 'new_message':
        final conversationId = data['conversation_id']?.toString();
        final sellerId = data['other_user_id']?.toString() ?? data['sender_id']?.toString();
        final carId = data['car_id']?.toString();
        final extras = <String, dynamic>{
          if (conversationId != null) 'conversation_id': conversationId,
          if (sellerId != null) 'seller_id': sellerId,
          if (carId != null) 'car_id': carId,
        };
        GRouter.router.go(
          '${GRouter.config.mainRoutes.messagesBasePage}/${GRouter.config.chatsRoutes.chatPage}',
          extra: extras,
        );
        break;
      case 'new_offer':
      case 'car_like':
      case 'car_comment':
      case 'car_updated':
      case 'price_drop':
      case 'car_status_changed':
      case 'car_state_changed':
        final carId = data['car_id']?.toString() ?? notification['car_id']?.toString();
        if (carId != null && carId.isNotEmpty) {
          GRouter.router.go(
            '${GRouter.config.mainRoutes.home}/${GRouter.config.homeRoutes.carDetails}',
            extra: {'id': carId},
          );
        }
        break;
      default:
        break;
    }
  }
}

class NotificationItemWidget extends StatelessWidget {
  final Map<String, dynamic> notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;
  
  const NotificationItemWidget({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final isRead = notification['read_at'] != null;
    final title = notification['title']?.toString() ?? 'notification'.tr();
    final body = notification['body']?.toString() ?? '';
    final sender = notification['sender'] as Map<String, dynamic>?;
    final senderName = sender?['full_name']?.toString() ?? 'user'.tr();
    final createdAt = notification['created_at']?.toString();
    
    return Dismissible(
      key: Key(notification['id'].toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: HWEdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: HWEdgeInsets.all(16),
          margin: HWEdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: isRead 
                ? AppColors.white.withValues(alpha: 0.05)
                : AppColors.primary.withValues(alpha: 0.15),
            border: Border.all(
              color: isRead 
                  ? AppColors.white.withValues(alpha: 0.2)
                  : AppColors.primary.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              if (!isRead)
                Container(
                  width: 8.w,
                  height: 8.h,
                  margin: HWEdgeInsets.only(right: 12),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: AppText(
                            title,
                            style: context.textTheme.bodyLarge?.b.s15
                                .withColor(AppColors.white),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            translation: false,
                          ),
                        ),
                        if (createdAt != null)
                          AppText(
                            _formatTime(createdAt),
                            style: context.textTheme.bodySmall?.withColor(AppColors.grey),
                            translation: false,
                          ),
                      ],
                    ),
                    4.verticalSpace,
                    AppText(
                      body,
                      style: context.textTheme.bodyMedium?.s13
                          .withColor(AppColors.white.withValues(alpha: 0.8)),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      translation: false,
                    ),
                    if (sender != null) ...[
                      4.verticalSpace,
                      AppText('from'.tr(args: [senderName]), style: context.textTheme.bodySmall?.withColor(AppColors.grey), translation: false),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  String _formatTime(String dateStr) {
    try {
      final date = DateTime.parse(dateStr).toLocal();
      final now = DateTime.now();
      final diff = now.difference(date);
      
      if (diff.inDays > 0) {
        return '${diff.inDays}d';
      } else if (diff.inHours > 0) {
        return '${diff.inHours}h';
      } else if (diff.inMinutes > 0) {
        return '${diff.inMinutes}m';
      } else {
        return 'الآن';
      }
    } catch (_) {
      return '';
    }
  }
}
