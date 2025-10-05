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
  });

  final String assetPath;
  final Color? svgColor;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: HWEdgeInsets.all(14),
        decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(8.r),
            border: isSelected
                ? Border.all(color: AppColors.primary, width: 1.2.r)
                : null),
        child: AppSvgPicture(
          assetPath,
          fit: BoxFit.contain,
          color: svgColor,
        ),
      ),
    );
  }
}
