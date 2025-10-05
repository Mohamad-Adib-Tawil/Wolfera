import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';

class SpaceTextWidget extends StatelessWidget {
  const SpaceTextWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 14.h,
      width: 1.w,
      color: AppColors.white,
      margin: HWEdgeInsets.symmetric(horizontal: 6),
    );
  }
}
