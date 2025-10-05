import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/generated/assets.dart';

class SendButton extends StatelessWidget {
  final VoidCallback? onTap;
  const SendButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42.h,
        width: 42.w,
        // margin: HWEdgeInsets.only(bottom: 10),
        alignment: Alignment.center,
        padding: HWEdgeInsets.all(6),
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(blurRadius: 8.7, color: AppColors.primary)],
        ),
        child: AppSvgPicture(
          Assets.svgSend,
          width: 25.w,
        ),
      ),
    );
  }
}
