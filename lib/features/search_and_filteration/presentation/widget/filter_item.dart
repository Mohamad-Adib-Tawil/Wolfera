import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/routing/router.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/generated/assets.dart';

class FilterItem extends StatelessWidget {
  final String title;
  final bool isAcitve;

  const FilterItem({super.key, this.isAcitve = false, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GRouter.router.pushNamed(GRouter.config.filterRoutes.filter);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        alignment: Alignment.center,
        padding: HWEdgeInsets.only(left: 8, right: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          // color: AppColors.grey.shade900,
          border: isAcitve
              ? Border.all(color: AppColors.primary, width: 1.6.r)
              : Border.all(color: AppColors.grey, width: 1.2.r),
        ),
        child: Row(
          children: [
            AppText(title,
                style: context.textTheme.titleMedium?.s13.m
                    .withColor(isAcitve ? AppColors.primary : AppColors.grey)),
            5.horizontalSpace,
            Padding(
              padding: HWEdgeInsets.only(top: 2),
              child: AppSvgPicture(Assets.svgArrowDown,
                  width: 8.r,
                  color: isAcitve ? AppColors.primary : AppColors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
