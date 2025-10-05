import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';

class CustomRadioButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Widget? leading;
  final VoidCallback? onTap;
  const CustomRadioButton(
      {super.key,
      this.onTap,
      this.isSelected = false,
      required this.title,
      this.leading});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 288.w,
        padding: HWEdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.grey,
              width: 1.r,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leading != null) ...[leading!, 12.horizontalSpace],
            AppText(
              title,
              style: context.textTheme.bodyMedium?.s20.r,
            ),
            const Spacer(),
            Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : null,
                border: Border.all(
                    color: AppColors.grey, width: isSelected ? 3.r : 2.5.r),
              ),
            )
          ],
        ),
      ),
    );
  }
}
