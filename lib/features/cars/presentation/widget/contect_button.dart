import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';

class ContectButton extends StatelessWidget {
  const ContectButton({
    super.key,
    required this.title,
    required this.svg,
    this.textWidth,
  });
  final String title, svg;
  final double? textWidth;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: HWEdgeInsets.only(left: 18, top: 10, bottom: 10, right: 20),
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 4),
                blurRadius: 4,
                spreadRadius: 4,
                color: AppColors.black.withValues(alpha: 0.25),
              ),
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppSvgPicture(
              svg,
              height: 20.h,
              width: 20.w,
            ),
            10.horizontalSpace,
            if (textWidth != null)
              SizedBox(
                width: textWidth,
                child: AppText(
                  title,
                  translation: false,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyLarge!.s18.b
                      .withColor(AppColors.blackLight),
                ),
              )
            else
              Expanded(
                child: AppText(
                  title,
                  translation: false,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyLarge!.s18.b
                      .withColor(AppColors.blackLight),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
