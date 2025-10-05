import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';

class SaveButtonProfile extends StatelessWidget {
  const SaveButtonProfile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        width: context.mediaQuery.size.width,
        padding: HWEdgeInsets.all(20),
        margin: HWEdgeInsets.only(bottom: 50),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: AppColors.primary,
        ),
        child: AppText(
          "Save",
          style: context.textTheme.bodyLarge!.s17.sb.withColor(AppColors.black),
        ),
      ),
    );
  }
}
