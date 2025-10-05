import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';

class TextWithBorderItemWidget extends StatelessWidget {
  const TextWithBorderItemWidget({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        margin: HWEdgeInsets.only(left: 18),
        alignment: Alignment.center,
        padding: HWEdgeInsets.symmetric(horizontal: 20),
        height: 45.h,
        // width: 100.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.greyStroke,
            width: 1.2.r,
          ),
        ),
        child: AppText(
          title,
          style: context.textTheme.bodyLarge?.s14.withColor(AppColors.white),
        ),
      ),
    );
  }
}
