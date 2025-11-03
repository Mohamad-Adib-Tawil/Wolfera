import 'package:flutter/material.dart';
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
  final String? title;
  final String? subtitle;
  final String? avatarUrl;
  final String? timeText;
  const ChatItem({
    super.key,
    this.onTap,
    this.index,
    this.title,
    this.subtitle,
    this.avatarUrl,
    this.timeText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
              (title == null || title!.isEmpty) ? 'User' : title!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.titleMedium.s15.r,
            ),
          ),
          const Spacer(),
          AppText(
            _formatTime(),
            style: context.textTheme.titleMedium?.copyWith(fontSize: 15),
          ),
        ],
      ),
    );
  }

  String _formatTime() {
    if (timeText == null || timeText!.isEmpty) return '';
    try {
      final dt = DateTime.tryParse(timeText!);
      if (dt == null) return '';
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inDays > 7) {
        return '${dt.day}/${dt.month}';
      } else if (diff.inDays > 0) {
        return '${diff.inDays}d';
      } else if (diff.inHours > 0) {
        return '${diff.inHours}h';
      } else if (diff.inMinutes > 0) {
        return '${diff.inMinutes}m';
      } else {
        return 'Now';
      }
    } catch (_) {
      return '';
    }
  }
}
