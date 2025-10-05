import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';

class CustomTextContainer extends StatelessWidget {
  final String text;
  final String? icon;
  final double maxWidth;
  const CustomTextContainer({
    super.key,
    required this.text,
    this.icon,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: HWEdgeInsets.only(left: 5, right: 6, top: 3, bottom: 3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
          border:
              Border.all(color: AppColors.white.withOpacity(0.6), width: 1.r)),
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 0, maxWidth: maxWidth),
        child: IntrinsicWidth(
          child: Row(
            children: [
              if (icon != null) ...[
                AppSvgPicture(
                  icon!,
                  width: 10.w,
                  height: 12.h,
                ),
                5.horizontalSpace
              ],
              AppText(
                text,
                style: context.textTheme.titleSmall?.s14.sb
                    .withColor(AppColors.white.withOpacity(0.8)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
