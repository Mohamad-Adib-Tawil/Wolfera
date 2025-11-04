import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/generated/assets.dart';

class ChatBubbleItemWidget extends StatelessWidget {
  const ChatBubbleItemWidget({
    super.key,
    required this.isCurrent,
    required this.messageText,
    this.messageTime,
    this.senderName,
    this.senderAvatar,
  });

  final bool isCurrent;
  final String messageText;
  final DateTime? messageTime;
  final String? senderName;
  final String? senderAvatar;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment:
          isCurrent ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment:
          isCurrent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          padding: HWEdgeInsets.only(top: 20, bottom: 20, right: 12, left: 20),
          width: context.mediaQuery.size.width * 0.6,
          decoration: BoxDecoration(
            color: isCurrent
                ? AppColors.primary.withValues(alpha: 0.8)
                : AppColors.white,
            borderRadius: BorderRadius.only(
              bottomLeft:
                  isCurrent ? Radius.circular(16.r) : Radius.circular(0.r),
              bottomRight:
                  isCurrent ? Radius.circular(0.r) : Radius.circular(16.r),
              topRight: Radius.circular(16.r),
              topLeft: Radius.circular(16.r),
            ),
          ),
          child: AppText(
            messageText,
            style: context.textTheme.bodyLarge!.s15
                .withColor(isCurrent ? AppColors.white : AppColors.black),
            translation: false,
          ),
        ),
        5.verticalSpace,
        Row(
          mainAxisAlignment:
              isCurrent ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment:
              isCurrent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Padding(
              padding: HWEdgeInsets.only(bottom: 1, right: 8),
              child: AppText(
                _formatTime(messageTime),
                style: context.textTheme.labelMedium.m,
                translation: false,
              ),
            ),
            isCurrent
                ? CircleAvatar(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.8),
                    radius: 7.5.r,
                    child: AppSvgPicture(
                      Assets.svgCheck,
                      height: 11.h,
                      width: 11.w,
                    ),
                  )
                : const SizedBox(),
            4.horizontalSpace,
          ],
        )
      ],
    );
  }
  
  String _formatTime(DateTime? dt) {
    if (dt == null) return '';
    final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }
}
