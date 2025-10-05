import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';

class StatusSectionWidget extends StatelessWidget {
  const StatusSectionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        2.verticalSpace,
        Divider(
          color: AppColors.grey,
          thickness: 1.r,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(
              'Status : Under reviewing',
              style: context.textTheme.bodyLarge!.xb.withColor(AppColors.white),
            ))
      ],
    );
  }
}
