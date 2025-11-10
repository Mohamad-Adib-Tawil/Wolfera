import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/generated/assets.dart';

class ChatsEmptyStateWidget extends StatelessWidget {
  const ChatsEmptyStateWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 235.h,
      child: Stack(alignment: Alignment.center, children: [
        Positioned(
          top: 0,
          left: 0.07.sw,
          child: AppSvgPicture(
            Assets.svgEmptyMessages,
            width: 265.w,
          ),
        ),
        Positioned(
          top: 180.h,
          left: 0,
          right: 0,
          child: AppText(
            "chat.empty_title",
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.s20.sb,
          ),
        ),
        Positioned(
          bottom: 0.h,
          left: 0,
          right: 0,
          child: AppText(
            "chat.empty_subtitle",
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium.s18.r.withColor(AppColors.grey),
          ),
        ),
      ]),
    );
  }
}
