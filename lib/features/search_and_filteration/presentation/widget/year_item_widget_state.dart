import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';

import 'package:wolfera/features/app/presentation/widgets/app_text.dart';

class YearItemWidget extends StatelessWidget {
  final String? selectedYear;
  final VoidCallback? onTap;

  const YearItemWidget({super.key, this.onTap, this.selectedYear});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        alignment: Alignment.center,
        height: 45.h,
        width: 110.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: selectedYear != null
                ? selectedYear != "0"
                    ? AppColors.primary
                    : AppColors.greyStroke
                : AppColors.greyStroke,
            width: 1.5.r,
          ),
        ),
        child: AppText(
          selectedYear != null
              ? selectedYear != ""
                  ? selectedYear.toString()
                  : "----"
              : "----",
          style: context.textTheme.bodyLarge?.s14.withColor(AppColors.white),
        ),
      ),
    );
  }
}
