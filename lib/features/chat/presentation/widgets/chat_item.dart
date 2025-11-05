import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/chat/presentation/widgets/circlue_user_image_widget.dart';

class ChatItem extends StatelessWidget {
  final int? index;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String? title;
  final String? subtitle;
  final String? avatarUrl;
  final String? timeText;
  final int unreadCount;
  const ChatItem({
    super.key,
    this.onTap,
    this.index,
    this.title,
    this.subtitle,
    this.avatarUrl,
    this.timeText,
    this.onLongPress,
    this.unreadCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CirclueUserImageWidget(
            width: 55,
            userImage: avatarUrl,
          ),
          14.horizontalSpace,
          Padding(
            padding: HWEdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                profileName(context),
                8.verticalSpace,
                lastMessage(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ConstrainedBox lastMessage(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 0, maxWidth: 210.w),
      child: AppText(
        (subtitle == null || subtitle!.isEmpty) ? '...' : subtitle!,
        style: context.textTheme.titleSmall.s13.l.withColor(AppColors.grey),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        translation: false,
      ),
    );
  }

  SizedBox profileName(BuildContext context) {
    return SizedBox(
      width: 265.w,
      child: Row(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: 0, maxWidth: 210.w),
            child: AppText(
              (title == null || title!.isEmpty) ? 'user'.tr() : title!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.titleMedium.s15.r,
              translation: false,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                _formatTime(),
                style: context.textTheme.titleMedium?.copyWith(fontSize: 15),
                translation: false,
              ),
              if (unreadCount > 0) ...[
                6.horizontalSpace,
                Container(
                  padding: HWEdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: BoxConstraints(minWidth: 18.w),
                  child: Center(
                    child: Text(
                      _formatCount(unreadCount),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime() {
    if (timeText == null || timeText!.isEmpty) return '';
    try {
      final raw = DateTime.tryParse(timeText!);
      if (raw == null) return '';
      final dt = raw.toLocal();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final thatDay = DateTime(dt.year, dt.month, dt.day);
      final diffDays = today.difference(thatDay).inDays;
      if (diffDays == 0) return 'today'.tr();
      if (diffDays == 1) return 'yesterday'.tr();
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return '';
    }
  }

  String _formatCount(int count) {
    if (count <= 0) return '';
    if (count > 99) return '99+';
    return count.toString();
  }
}
