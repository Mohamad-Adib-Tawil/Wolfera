import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';

class NavBarItemCircular extends StatelessWidget {
  final String svgAsset;
  final bool isSelected;
  final VoidCallback onTap;

  const NavBarItemCircular({
    super.key,
    required this.svgAsset,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.white, width: 5.w),
            borderRadius: BorderRadius.circular(60).r,
            color: AppColors.orange),
        width: 70.w,
        height: 70.h,
        child: Center(
          child: AppSvgPicture(
            svgAsset,
            width: 28.w,
            color: AppColors.white,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
