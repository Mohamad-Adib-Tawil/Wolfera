import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';

class CustomRectangleWithIconButton extends StatelessWidget {
  final String svgPicture;
  final double? height;
  final double? width;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? iconHeight;
  final double? iconWidth;
  final void Function()? onTab;
  const CustomRectangleWithIconButton({
    super.key,
    required this.svgPicture,
    this.height,
    this.width,
    this.backgroundColor,
    this.iconColor,
    this.onTab,
    this.iconHeight,
    this.iconWidth,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTab,
      child: Container(
        width: width ?? 87.w,
        height: height ?? 87.h,
        padding: HWEdgeInsets.all(30),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: backgroundColor ?? const Color(0xffe2e2e3),
          ),
        ),
        child: AppSvgPicture(
          svgPicture,
          height: iconHeight ?? 28.h,
          width: iconWidth ?? 34,
          color: iconColor ?? AppColors.grey,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
