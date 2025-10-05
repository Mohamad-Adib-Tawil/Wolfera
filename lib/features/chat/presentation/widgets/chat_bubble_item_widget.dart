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
  });

  final bool isCurrent;

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
                ? AppColors.primary.withOpacity(0.8)
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
            'Lorem ipsum dolor sit amet consectetur Vitae turpis eget cras',
            style: context.textTheme.bodyLarge!.s15
                .withColor(isCurrent ? AppColors.white : AppColors.black),
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
                '12:00 am',
                style: context.textTheme.labelMedium.m,
              ),
            ),
            isCurrent
                ? CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.8),
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
}
