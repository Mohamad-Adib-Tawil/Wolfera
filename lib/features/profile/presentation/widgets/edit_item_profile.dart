import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';

class EditItemProfile extends StatelessWidget {
  const EditItemProfile({
    super.key,
    required this.text,
    required this.svg,
  });
  final String text;
  final String svg;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: HWEdgeInsets.all(20),
      margin: HWEdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: AppColors.white,
      ),
      child: Row(
        children: [
          4.horizontalSpace,
          AppSvgPicture(
            svg,
            color: AppColors.black,
          ),
          16.horizontalSpace,
          AppText(
            text,
            style:
                context.textTheme.bodyLarge!.s17.sb.withColor(AppColors.black),
          ),
        ],
      ),
    );
  }
}
