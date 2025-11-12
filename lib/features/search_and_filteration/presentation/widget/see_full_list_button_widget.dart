import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';

class SeeFullListButtonWidget extends StatelessWidget {
  final VoidCallback? onTap;
  const SeeFullListButtonWidget({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: 140.w,
          height: 40.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            color: AppColors.grey.withValues(alpha: .2),
          ),
          child: AppText(
            'see_full_list',
            style: context.textTheme.bodyLarge?.s15.withColor(AppColors.white),
          )),
    );
  }
}
