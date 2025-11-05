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
  final int? badgeCount;

  const NavBarItem({
    super.key,
    required this.svgAsset,
    required this.isSelected,
    required this.onTap,
    required this.title,
    this.badgeCount,
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
            Stack(
              clipBehavior: Clip.none,
              children: [
                AppSvgPicture(
                  svgAsset,
                  width: 20.w,
                  height: 22.h,
                  color: isSelected ? AppColors.orange : AppColors.greyStroke,
                  fit: BoxFit.cover,
                ),
                if ((badgeCount ?? 0) > 0)
                  Positioned(
                    top: -6,
                    right: -10,
                    child: Container(
                      padding: HWEdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.blackLight, width: 1),
                      ),
                      constraints: BoxConstraints(minWidth: 16.w),
                      child: Text(
                        _formatCount(badgeCount!),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          height: 1.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
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

  String _formatCount(int count) {
    if (count <= 0) return '';
    if (count > 99) return '99+';
    return count.toString();
  }
}
