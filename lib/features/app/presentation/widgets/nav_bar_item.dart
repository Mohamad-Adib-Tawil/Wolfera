import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';

class NavBarItem extends StatelessWidget {
  final String svgAsset;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const NavBarItem({
    super.key,
    required this.svgAsset,
    required this.isSelected,
    required this.onTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 50.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppSvgPicture(
              svgAsset,
              width: 20.w,
              height: 22.h,
              color: isSelected ? AppColors.orange : AppColors.greyStroke,
              fit: BoxFit.cover,
            ),
            5.verticalSpace,
            Padding(
              padding: HWEdgeInsetsDirectional.only(
                start: 2,
              ),
              child: AppText(
                title,
                style: context.textTheme.bodyMedium.m.withColor(
                    isSelected ? AppColors.orange : AppColors.greyStroke),
              ),
            )
          ],
        ),
      ),
    );
  }
}
