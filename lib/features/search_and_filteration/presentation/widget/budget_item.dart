import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/common/enums/budget_filter.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';

class BudgetItem extends StatelessWidget {
  final BudgetFiltertype item;
  final bool isSelected;
  final VoidCallback onTap;

  const BudgetItem({
    super.key,
    required this.item,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        height: 50.h,
        padding: HWEdgeInsets.symmetric(
          horizontal: isSelected ? 28 : 20,
          vertical: 6,
        ),
        margin: HWEdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.08)
              : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.greyStroke,
            width: 1.5.r,
          ),
          borderRadius: BorderRadius.circular(8).r,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.16),
                    blurRadius: 6.r,
                    spreadRadius: 0.15,
                  )
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(
              item.title,
              style:
                  context.textTheme.titleSmall.s10.b.withColor(AppColors.grey),
            ),
            4.verticalSpace,
            AppText(
              item.range,
              style:
                  context.textTheme.titleSmall.s10.sb.withColor(AppColors.white),
            ),
          ],
        ),
      ),
    );
  }
}
