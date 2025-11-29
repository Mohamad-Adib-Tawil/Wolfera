import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';

class CarLogoItem extends StatelessWidget {
  const CarLogoItem({
    super.key,
    required this.assetPath,
    required this.svgColor,
    this.isSelected = false,
    this.onTap,
    this.label,
  });

  final String assetPath;
  final Color? svgColor;
  final bool isSelected;
  final VoidCallback? onTap;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: HWEdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(8.r),
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 1.2.r)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: AppSvgPicture(
                assetPath,
                fit: BoxFit.contain,
                color: svgColor,
              ),
            ),
            if (label != null) ...[
              SizedBox(height: 6.h),
              Text(
                label!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
